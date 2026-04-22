module "homelab_infra_services" {
  source                 = "../../../modules/blueprint"
  cluster_name           = "homelab-infra-services"
  cluster_provider       = "Kind"
  disable_default_cni    = true
  create_cluster_storage = true

  coredns_forward_ip  = "172.18.0.14"
  coredns_custom_zone = "cacetinho.internal.infra"



  extra_port_mappings = [
    {
      container_port = 30080
      host_port      = 80
      protocol       = "TCP"
    },
    {
      container_port = 30443
      host_port      = 443
      protocol       = "TCP"
    }
  ]

  nodes = [
    {
      role           = "control-plane"
      enable_storage = true
      labels = {
        ingress-ready = "true"
        platform      = "true"
        storage       = "enabled"
      }
    },
    {
      role           = "worker"
      enable_storage = false
      labels = {
        workload = "general"
        tier     = "application"
      }
    },
    {
      role           = "worker"
      enable_storage = false
      labels = {
        workload = "general"
        tier     = "application"
        storage  = "enabled"

      }
    },
    {
      role           = "worker"
      enable_storage = false
      labels = {
        workload = "general"
        tier     = "application"
        storage  = "enabled"

      }
    },
  ]

}
