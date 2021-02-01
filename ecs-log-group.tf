resource "aws_cloudwatch_log_group" "ecs-task-log" {
  for_each = { for c in var.containers : c.app-name => c }
  name     = "/ecs/${local.project-name-hyphated}/${each.value.app-name}"

  tags = merge(local.common_tags, {
    service  = "ecs-task"
    app-name = "${lower(var.env)}-${each.value.app-name}"
  })
}