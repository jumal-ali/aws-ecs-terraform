resource "aws_ecs_cluster" "ecs" {
  name               = "${lower(var.env)}-${local.project-name-hyphated}"
  capacity_providers = ["FARGATE"]

  tags = local.common_tags
}