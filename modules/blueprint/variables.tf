## KUBERNETES VALUES
variable "cluster_name" {
  type = string
}

variable "cluster_provider" {
  type        = string
  description = "Defines the provider of the cluster. Ex. EKS, GKE, Kind. "
}

variable "disable_default_cni" {
  type    = bool
  default = false
}

variable "extra_port_mappings" {
  type = list(object({
    container_port = number
    host_port      = number
    protocol       = string
  }))
  default = []
}

variable "nodes" {
  type = list(object({
    role           = string
    enable_storage = bool
    labels         = map(string)
  }))
  default = [{
    labels         = {}
    enable_storage = false
    role           = ""
  }]
}

# COREDNS VALUES 
variable "coredns_forward_ip" {
  description = "upstream IP of the custom zone"
  type        = string
}

variable "coredns_custom_zone" {
  description = "DNS custom zone on the  domain:port format (ex: homelab.infra.com:53)"
  type        = string
}

# OPEN EBS VALUES
variable "create_cluster_storage" {
  type    = bool
  default = false
}


