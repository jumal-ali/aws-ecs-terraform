locals {
  common_tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project-name
  }

  container = {
    image = var.container-image
    tag   = var.container-tag
    port  = var.container-port
    mem   = var.container-mem
    cpu   = var.container-cpu
  }
}