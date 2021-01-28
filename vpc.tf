module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${lower(var.env)} ${lower(var.project-name)} vpc"
  cidr = var.vpc-cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = length(var.private_subnets) > 0 ? true : false

  tags = local.common_tags
}