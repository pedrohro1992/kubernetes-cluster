resource "helm_release" "vaultweaver" {
  name             = "vaultweaver"
  repository       = "oci://registry-1.docker.io/phroliveira"
  chart            = "vaultweaver"
  version          = "0.1.1"
  namespace        = kubernetes_namespace_v1.vaultweaver.metadata[0].name
  create_namespace = false


  values = [
    templatefile("${path.module}/templates/values.yaml", {
      replicas              = var.operator_replicas
      repository            = "phroliveira/vaultweaver"
      tag                   = "v0.1.0"
      vault_addr            = var.vault_addr
      vault_kubernetes_role = "${var.k8s_service_account_name}-role"
    })
  ]

  depends_on = [vault_kubernetes_auth_backend_role.vaultreaver_role]
}
