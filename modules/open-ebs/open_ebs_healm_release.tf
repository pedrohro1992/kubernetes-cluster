resource "helm_release" "openebs" {
  name             = "openebs"
  repository       = "https://openebs.github.io/openebs"
  chart            = "openebs"
  version          = "4.1.3"
  namespace        = "openebs"
  create_namespace = true

  values = [
    templatefile("${path.module}/templates/openebs-values.yaml", {
      base_path = var.openebs_base_path
    })
  ]
}
