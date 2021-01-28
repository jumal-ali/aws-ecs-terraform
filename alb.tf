resource "aws_alb" "ecs-alb" {
  name               = "${lower(var.env)}-${local.project-name-hyphated}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets

  tags = local.common_tags
}

resource "aws_security_group" "alb-sg" {
  name        = "${lower(var.env)}-${local.project-name-hyphated}-alb-sg"
  description = "${var.env} ${var.project-name} ALB Security Group"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = { for c in var.containers : c.app-name => c }

    content {
      description = "HTTP"
      from_port   = ingress.value.host-port
      to_port     = ingress.value.host-port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  for_each = { for c in var.containers : c.app-name => c }

  load_balancer_arn = aws_alb.ecs-alb.arn
  port              = each.value.host-port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-alb-task-tg[each.value.app-name].arn
  }
}

resource "aws_lb_target_group" "ecs-alb-task-tg" {
  for_each = { for c in var.containers : c.app-name => c }

  name        = "${lower(var.env)}-${local.project-name-hyphated}-${each.value.app-name}-tg"
  port        = each.value.container-port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = each.value.container-port
    matcher             = 200
    interval            = 60
    timeout             = 20
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags       = local.common_tags
  depends_on = [aws_alb.ecs-alb]
}