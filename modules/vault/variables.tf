variable "vault_namespace" {
  description = "Namespace where Vault will be installed"
  type        = string
  default     = "vault-system"
}

variable "vault_chart_version" {
  description = "Vault Helm chart version"
  type        = string
  default     = "0.27.0"
}

variable "database_name" {
  description = "Name of the custom database resource"
  type        = string
  default     = "vault-db"
}

variable "database_namespace" {
  description = "Namespace where the database custom resource is created"
  type        = string
  default     = "vault-system"
}
