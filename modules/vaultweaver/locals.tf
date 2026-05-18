locals {
  role_binding_name = "${var.k8s_service_account_name}-binding"
  kubernetes_host   = data.external.kubernetes_api_address.result.host
}
