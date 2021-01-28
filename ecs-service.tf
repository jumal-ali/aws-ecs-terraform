resource "aws_ecs_service" "ecs-service" {
  for_each = { for c in var.containers : c.app-name => c }

  name            = "${lower(var.env)}-${each.value.app-name}-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs-task[each.value.app-name].arn
  desired_count   = 2
  launch_type     = "FARGATE"
  propagate_tags  = "SERVICE"

  network_configuration {
    security_groups  = [aws_security_group.ecs-task-app-sg[each.value.app-name].id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-alb-task-tg[each.value.app-name].arn
    container_name   = each.value.app-name
    container_port   = each.value.container-port
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  tags = merge(local.common_tags, {
    image = each.value.image
    app   = "${lower(var.env)}-${each.value.app-name}"
  })
}