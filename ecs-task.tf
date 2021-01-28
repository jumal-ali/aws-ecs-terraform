resource "aws_ecs_task_definition" "ecs-task" {
  for_each = { for c in var.containers : c.app-name => c }

  family = "${lower(var.env)}-${each.value.app-name}"
  container_definitions = templatefile("${path.module}/templates/ecs-container-definition.tpl", {
    image                = each.value.image
    tag                  = each.value.tag
    container-port       = each.value.container-port
    cpu                  = each.value.cpu
    memory               = each.value.memory
    app-name             = each.value.app-name
    awslogs-region       = data.aws_region.current.name
    awslogs-group        = "/ecs/${local.project-name-hyphated}/${each.value.app-name}"
    healthcheck-commands = jsonencode(each.value.healthcheck-commands)
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = each.value.memory
  cpu                      = each.value.cpu
  execution_role_arn       = aws_iam_role.ecs-task-exec-role[each.value.app-name].arn

  tags = merge(local.common_tags, {
    app-name = "${lower(var.env)}-${each.value.app-name}"
  })
}

resource "aws_iam_role" "ecs-task-exec-role" {
  for_each = { for c in var.containers : c.app-name => c }

  name_prefix = "${lower(var.env)}-${each.value.app-name}-task-execution"
  path        = "/ecs-task/"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF

  tags = merge(local.common_tags, {
    app-name = "${lower(var.env)}-${each.value.app-name}"
  })
}

resource "aws_iam_role_policy" "ecs-task-exec-policy" {
  for_each = { for c in var.containers : c.app-name => c }

  name_prefix = "${lower(var.env)}-${each.value.app-name}"
  role        = aws_iam_role.ecs-task-exec-role[each.value.app-name].id

  policy = templatefile("${path.module}/templates/policy-exec-task.tpl", {
    aws-account-id = data.aws_caller_identity.current.account_id
    aws-region     = data.aws_region.current.name
    log-group      = "/ecs/${local.project-name-hyphated}/${each.value.app-name}"
  })
}

resource "aws_security_group" "ecs-task-app-sg" {
  for_each = { for c in var.containers : c.app-name => c }

  name_prefix = "${lower(var.env)}-${each.value.app-name}-task-sg"
  description = "${var.env} ${each.value.app-name} ecs task"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP"
    from_port       = each.value.container-port
    to_port         = each.value.container-port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    app-name = "${lower(var.env)}-${each.value.app-name}"
  })
}