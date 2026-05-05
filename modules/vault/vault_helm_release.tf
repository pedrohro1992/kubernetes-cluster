resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.vault_namespace
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.vault_chart_version
  namespace  = kubernetes_namespace.vault.metadata[0].name

  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true

  values = [
    templatefile("${path.module}/templates/vault-values.yaml", {
      database_secret_name = "${var.database_name}-app" # Expected secret created by CloudNativePG
    })
  ]

  depends_on = [
    kubernetes_manifest.vault_database
  ]
}
