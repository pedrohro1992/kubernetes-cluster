resource "helm_release" "postgresql" {
  name             = "postgresql"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "postgresql"
  version          = "16.4.1" # Versão estável do Chart Bitnami
  namespace        = "database"
  create_namespace = true

  timeout         = 600
  atomic          = true
  cleanup_on_fail = true

  values = [
    templatefile("${path.module}/templates/postgres-values.yaml", {
      postgres_password   = var.postgres_root_password
      persistence_enabled = var.postgres_persistence
    })
  ]
}
