#!/bin/bash

VAULT_NAMESPACE=$1
SECRET_NAME="vault-unseal-keys"

echo "--- Unsealing Vault Pods ---"

# Retrieve unseal keys from Kubernetes Secret
if kubectl get secret "${SECRET_NAME}" -n "${VAULT_NAMESPACE}" &> /dev/null; then
  UNSEAL_KEY_1=$(kubectl get secret "${SECRET_NAME}" -n "${VAULT_NAMESPACE}" -o jsonpath='{.data.unseal-key-1}' | base64 --decode)
  UNSEAL_KEY_2=$(kubectl get secret "${SECRET_NAME}" -n "${VAULT_NAMESPACE}" -o jsonpath='{.data.unseal-key-2}' | base64 --decode)
  
  if [ -z "$UNSEAL_KEY_1" ] || [ -z "$UNSEAL_KEY_2" ]; then
    echo "Error: Could not retrieve unseal keys from secret '${SECRET_NAME}'. Aborting unseal process."
    exit 1
  fi
  echo "Unseal keys retrieved from Kubernetes Secret '${SECRET_NAME}'."
else
  echo "Error: Kubernetes Secret '${SECRET_NAME}' not found in namespace '${VAULT_NAMESPACE}'. Cannot unseal Vault."
  echo "Ensure Vault has been initialized and the secret created by init-vault.sh."
  exit 1
fi

# Get all Vault pod names
VAULT_PODS=$(kubectl get pods -n "${VAULT_NAMESPACE}" -l app.kubernetes.io/name=vault -o custom-columns=NAME:.metadata.name --no-headers | tr '\n' ' ')

for POD in $VAULT_PODS; do
  echo "Attempting to unseal $POD..."
  # Check if pod is already unsealed
  if kubectl exec -n "${VAULT_NAMESPACE}" "$POD" -- vault status -format=json | grep -q '"sealed": true'; then
    echo "$POD is sealed. Unsealing..."
    kubectl exec -n "${VAULT_NAMESPACE}" "$POD" -- vault operator unseal "$UNSEAL_KEY_1"
    kubectl exec -n "${VAULT_NAMESPACE}" "$POD" -- vault operator unseal "$UNSEAL_KEY_2"
    echo "$POD unseal commands sent."
  else
    echo "$POD appears to be unsealed."
  fi
done

# Note: We are no longer cleaning up /tmp files as they are not used.
# The Kubernetes secret will persist. Consider a separate mechanism if you need to delete it.
echo "Unseal process finished. The Kubernetes secret '${SECRET_NAME}' still exists."