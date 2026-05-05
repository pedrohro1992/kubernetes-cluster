# This creates the Custom Resource managed by your platform-operator,
# which in turn creates the CloudNativePG PostgreSQL database.
resource "kubernetes_manifest" "vault_database" {
  manifest = {
    apiVersion = "database.platform.io/v1alpha1"
    kind       = "PGDatabase"
    metadata = {
      name      = var.database_name
      namespace = kubernetes_namespace.vault.metadata[0].name
    }
    spec = {
      instances   = 3
      storageSize = "2Gi"
      version     = "16"
    }
  }

  depends_on = [kubernetes_namespace.vault]
}
