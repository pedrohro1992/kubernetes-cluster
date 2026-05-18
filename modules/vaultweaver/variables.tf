variable "cluster_name" {
  type = string
}

variable "k8s_service_account_name" {
  type        = string
  description = "Name of the ServiceAccount and RoleBinding that will be created on the cluster"
  default     = "vaultweaver-operator"
}

variable "kubernetes_ca_cert" {
  type        = string
  description = "PEM encoded CA cert for use by the TLS client used to talk with the Kubernetes API."
}

variable "operator_replicas" {
  type        = string
  description = "Number of replicas on the operator"
  default     = "1"
}

variable "vault_addr" {
  type        = string
  description = "Address of the Hashicorp vault"
}
