variable "postgres_root_password" {
  type        = string
  description = "Root password for the PostgreSQL instance"
  sensitive   = true
}

variable "postgres_persistence" {
  type        = bool
  description = "Enable or disable persistent volume for PostgreSQL"
  default     = false # Recomendado false para testes rápidos no Kind
}
