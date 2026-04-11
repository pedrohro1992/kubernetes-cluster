resource "helm_release" "calico_operator" {
  name             = "calico"
  namespace        = "tigera-operator"
  create_namespace = true

  repository = "https://docs.tigera.io/calico/charts"
  chart      = "tigera-operator"
  version    = "v3.31.3"

  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  dependency_update = true

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      pod_cidr            = var.pod_network_cidr
      kubernetes_provider = var.cluster_provider
    })
  ]
}
