module "cluster_kind" {
  source       = "../kind"
  count        = local.cluster_type_kind ? 1 : 0
  cluster_name = var.cluster_name

  disable_default_cni    = var.disable_default_cni
  extra_port_mappings    = var.extra_port_mappings
  nodes                  = var.nodes
  create_cluster_storage = var.create_cluster_storage
}

module "calico_network" {
  source = "../calico"

  cluster_provider = var.cluster_provider

  depends_on = [module.cluster_kind]
}

module "open_ebs_storage" {
  source = "../open-ebs"

  depends_on = [module.calico_network]
}

module "vaultreaver" {
  source = "../vaultweaver"

  cluster_name       = var.cluster_name
  kubernetes_ca_cert = base64decode(module.cluster_kind[0].cluster_ca_certificate)

  vault_addr = "http://172.18.0.12:8200"

}

# module "cloudnative_pg" {
#   source = "../cloudnative-pg"
#
#   depends_on = [module.open_ebs_storage]
# }
#
# module "vault" {
#   source = "../vault"
#
#   depends_on = [module.cloudnative_pg]
# }

# module "external_secrets_operator" {
#   source = "../external-secrets-operator"
#
#   depends_on = [module.vault]
# }

# module "platform_operator" {
#   source = "../platform-operator"
#
#   depends_on = [module.open_ebs_storage]
# }
