resource "kubernetes_namespace_v1" "eso" {
  metadata {
    name = "external-secrets"
  }
}


resource "helm_release" "external_secrets" {
  name       = "external-secret"
  namespace  = kubernetes_namespace_v1.eso.metadata[0].name
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "2.0.1"

  values = [
    templatefile("${path.module}/templates/eso-values.yaml", {
      sa-name = "eso-sa"
    })
  ]

}
