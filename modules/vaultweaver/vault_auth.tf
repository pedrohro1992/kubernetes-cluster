resource "vault_auth_backend" "vaultreaver" {
  type = "kubernetes"

  depends_on = [kubernetes_secret_v1.vaultweaver_token]
}

resource "vault_kubernetes_auth_backend_config" "vaultreaver_config" {
  backend         = vault_auth_backend.vaultreaver.path
  kubernetes_host = local.kubernetes_host
  # kubernetes_host    = "https://kubernetes.default.svc"
  kubernetes_ca_cert = var.kubernetes_ca_cert
  token_reviewer_jwt = kubernetes_secret_v1.vaultweaver_token.data["token"]

  disable_local_ca_jwt = true
}

resource "vault_policy" "vaultreaver_policy" {
  name   = "${var.k8s_service_account_name}-policy"
  policy = <<EOT
path "auth/${vault_auth_backend.vaultreaver.path}/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "vaultreaver_role" {
  backend                          = vault_auth_backend.vaultreaver.path
  role_name                        = "${var.k8s_service_account_name}-role"
  bound_service_account_names      = [kubernetes_service_account_v1.vaultweaver.metadata[0].name]
  bound_service_account_namespaces = [kubernetes_namespace_v1.vaultweaver.metadata[0].name]
  token_policies                   = [vault_policy.vaultreaver_policy.name]
  token_ttl                        = 36000
}
