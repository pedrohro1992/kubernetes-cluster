locals {
  cluster_type_kind = var.cluster_provider == "Kind" ? true : false
}
