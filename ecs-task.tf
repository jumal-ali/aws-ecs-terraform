resource "aws_ecs_task_definition" "web-app" {
  family = "${var.env}-web-app"
  container_definitions = templatefile("${path.module}/ecs-container-definitions/web-app.tpl", {
    image = local.container.image
    tag   = local.container.tag
    port  = local.container.port
    cpu   = local.container.cpu
    mem   = local.container.mem
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = local.container.mem
  cpu                      = local.container.cpu
  execution_role_arn       = aws_iam_role.ecs-task-exec-role.arn

  tags = merge(local.common_tags, local.container, {
    service = "${var.env}-web-app"
  })
}

resource "aws_iam_role" "ecs-task-exec-role" {
  name_prefix = "${var.env}-ecs-task-execution"
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

  tags = local.common_tags
}

resource "aws_iam_role_policy" "ecs-task-exec-policy" {
  name_prefix = "${var.env}-web-app"
  role        = aws_iam_role.ecs-task-exec-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}