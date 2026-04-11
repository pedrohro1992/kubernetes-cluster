variable "pod_network_cidr" {
  description = "CIDR da rede de Pods do cluster."
  type        = string
  default     = "10.244.0.0/16"
}

variable "cluster_provider" {
  type        = string
  description = "Defines the provider of the cluster. Ex. EKS, GKE, Kind. "
}

