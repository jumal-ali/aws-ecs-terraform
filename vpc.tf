module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-ecs-vpc"
  cidr = var.vpc-cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = local.common_tags
}