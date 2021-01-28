resource "aws_iam_user" "deployer" {
  name = "${lower(var.env)}-ci-bot"
  path = "/deployer/"

  tags = local.common_tags
}

resource "aws_iam_policy" "deployment-policy" {
  path        = "/deployment/"
  description = "Deployment Policy For ${lower(var.env)} ci-bot"

  policy = templatefile("${path.module}/templates/iam-deploy-policy.tpl", {
    ecs-service-arn    = jsonencode([for k, v in aws_ecs_service.ecs-service : v.id])
    task-exec-role-arn = jsonencode([for k, v in aws_iam_role.ecs-task-exec-role : v.arn])
  })

  depends_on = [aws_ecs_service.ecs-service, aws_iam_role.ecs-task-exec-role]
}

resource "aws_iam_user_policy_attachment" "attach-deployment-policy" {
  user       = aws_iam_user.deployer.name
  policy_arn = aws_iam_policy.deployment-policy.arn
}