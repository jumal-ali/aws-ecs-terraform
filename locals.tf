locals {
  project-name-hyphated = replace(lower(var.project-name), " ", "-")

  common_tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project-name
  }
}

