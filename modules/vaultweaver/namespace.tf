resource "kubernetes_namespace_v1" "vaultweaver" {
  metadata {
    name = var.k8s_service_account_name
  }
}

