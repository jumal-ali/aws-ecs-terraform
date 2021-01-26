resource "aws_alb" "ecs-alb" {
  name               = "${var.env}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.ecs-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg.arn
  }
}

resource "aws_lb_target_group" "ecs-tg" {
  name        = "${var.env}-ecs-web-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = local.container.port
    matcher             = 200
    interval            = 60
    timeout             = 20
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags       = local.common_tags
  depends_on = [aws_alb.ecs-alb]
}

resource "aws_security_group" "alb-sg" {
  name        = "${var.env}-ecs-web-app-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}