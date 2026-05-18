resource "kubernetes_service_account_v1" "vaultweaver" {
  metadata {
    name      = "vaultweaver-operator"
    namespace = kubernetes_namespace_v1.vaultweaver.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "vaultweaver_binding" {
  metadata {
    name = local.role_binding_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.vaultweaver.metadata[0].name
    namespace = kubernetes_namespace_v1.vaultweaver.metadata[0].name
  }
}

resource "kubernetes_secret_v1" "vaultweaver_token" {
  metadata {
    name      = local.role_binding_name
    namespace = kubernetes_namespace_v1.vaultweaver.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.vaultweaver.metadata[0].name
    }
  }

  type       = "kubernetes.io/service-account-token"
  depends_on = [kubernetes_cluster_role_binding_v1.vaultweaver_binding]
}
