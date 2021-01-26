resource "aws_ecs_cluster" "ecs" {
  name               = "${var.env}-super-awesome"
  capacity_providers = ["FARGATE"]

  tags = local.common_tags
}