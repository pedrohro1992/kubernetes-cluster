resource "helm_release" "platform_operator" {
  name             = "platform-operator"
  repository       = "oci://registry-1.docker.io/opedroramos"
  chart            = "platform-operator"
  version          = "2.0.2"
  namespace        = "platform-system"
  create_namespace = true

  # OCI requer autenticação se o repositório não for público
  # As credenciais devem ser configuradas no provider "helm"

  values = [
    templatefile("${path.module}/templates/operator-values.yaml", {
      replicas   = var.operator_replicas
      repository = "opedroramos/platform-operator"
      tag        = "2.0"
    })
  ]
}
