resource "null_resource" "vault_init_unseal" {
  # This ensures the null_resource only runs after the Helm chart has been deployed.
  # Adjust this dependency if your Vault deployment resource has a different name.
  depends_on = [
    helm_release.vault
  ]

  # Provisioner for initialization
  provisioner "local-exec" {
    # Ensure the script is executable
    command = "chmod +x ${path.module}/scripts/init-vault.sh && ${path.module}/scripts/init-vault.sh ${var.vault_namespace} vault-0"
    # Only run this provisioner on creation of the resource.
    when = create
  }

  # Provisioner for unsealing each pod
  provisioner "local-exec" {
    # Ensure the script is executable
    command = "chmod +x ${path.module}/scripts/unseal-vault.sh && ${path.module}/scripts/unseal-vault.sh ${var.vault_namespace}"
    # This should also run on creation, after the init.
    when = create
  }
}
