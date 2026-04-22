module "cluster_kind" {
  source       = "../kind"
  count        = local.cluster_type_kind ? 1 : 0
  cluster_name = var.cluster_name

  disable_default_cni    = var.disable_default_cni
  extra_port_mappings    = var.extra_port_mappings
  nodes                  = var.nodes
  create_cluster_storage = var.create_cluster_storage
}

module "coredns_cm" {
  source = "../coredns-config"

  cluster_name        = var.cluster_name
  coredns_forward_ip  = var.coredns_forward_ip
  coredns_custom_zone = var.coredns_custom_zone

  depends_on = [module.cluster_kind]

}

module "calico_network" {
  source = "../calico"

  cluster_provider = var.cluster_provider

  depends_on = [module.coredns_cm]
}

module "open_ebs_storage" {
  source = "../open-ebs"

  depends_on = [module.calico_network]
}

module "platform_operator" {
  source = "../platform-operator"

  depends_on = [module.open_ebs_storage]
}
