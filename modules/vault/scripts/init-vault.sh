#!/bin/bash

VAULT_NAMESPACE=$1
POD_NAME=$2 # This will be vault-0
SECRET_NAME="vault-unseal-keys"

echo "--- Initializing Vault ---"

# Check if Vault is already initialized
if kubectl exec -n "${VAULT_NAMESPACE}" "${POD_NAME}" -- vault status -format=json | grep -q '"initialized": false'; then
  echo "Vault is not initialized. Initializing now..."
  
  # Run init and capture output for unseal keys and root token
  INIT_OUTPUT=$(kubectl exec -n "${VAULT_NAMESPACE}" "${POD_NAME}" -- vault operator init -key-shares=3 -key-threshold=2)
  echo "$INIT_OUTPUT"

  # Extract Unseal Keys and Root Token.
  UNSEAL_KEY_1=$(echo "$INIT_OUTPUT" | grep "Unseal Key 1:" | awk '{print $NF}')
  UNSEAL_KEY_2=$(echo "$INIT_OUTPUT" | grep "Unseal Key 2:" | awk '{print $NF}')
  ROOT_TOKEN=$(echo "$INIT_OUTPUT" | grep "Initial Root Token:" | awk '{print $NF}')

  # Check if the secret already exists to ensure idempotency
  if ! kubectl get secret "${SECRET_NAME}" -n "${VAULT_NAMESPACE}" &> /dev/null; then
    echo "--- Creating Kubernetes Secret '${SECRET_NAME}' for unseal keys and root token ---"
    kubectl create secret generic "${SECRET_NAME}" \
      --from-literal="unseal-key-1=${UNSEAL_KEY_1}" \
      --from-literal="unseal-key-2=${UNSEAL_KEY_2}" \
      --from-literal="root-token=${ROOT_TOKEN}" \
      -n "${VAULT_NAMESPACE}"
    echo "Kubernetes Secret '${SECRET_NAME}' created in namespace '${VAULT_NAMESPACE}'."
    echo "WARNING: This secret contains sensitive data. Ensure it is handled securely."
  else
    echo "Kubernetes Secret '${SECRET_NAME}' already exists. Skipping creation."
  fi
else
  echo "Vault appears to be already initialized."
fi