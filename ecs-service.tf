resource "aws_ecs_service" "ecs-service" {
  name            = "${var.env}-web-app-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.web-app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs-task-web-app.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-tg.arn
    container_name   = "web-app"
    container_port   = local.container.port
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  tags = merge(local.common_tags, {
    service = "${var.env}-web-app"
  })
}

resource "aws_security_group" "ecs-task-web-app" {
  name_prefix = "${var.env}-ecs-task-web-app"
  description = "${var.env} web app ecs task"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP"
    from_port       = local.container.port
    to_port         = local.container.port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}