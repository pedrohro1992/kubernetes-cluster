resource "helm_release" "cloudnative_pg" {
  name             = "cloudnative-pg"
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  version          = "0.22.1" # Versão estável atual
  namespace        = "cnpg-system"
  create_namespace = true

  timeout         = 600
  atomic          = true
  cleanup_on_fail = true

  values = [
    templatefile("${path.module}/templates/cnpg-values.yaml", {})
  ]
}
