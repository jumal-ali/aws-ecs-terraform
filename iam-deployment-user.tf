resource "aws_iam_user" "deployer" {
  name = "${var.env}-web-app-ci-bot"
  path = "/deployer/"

  tags = local.common_tags
}

resource "aws_iam_policy" "deployment-policy" {
  name_prefix = "${var.env}-web-app"
  path        = "/deployment/"
  description = "Deployment Policy For ${var.env}-web-app"

  policy = templatefile("${path.module}/templates/iam-deploy-policy.tpl", {
    ecs-service-arn    = aws_ecs_service.ecs-service.id
    task-exec-role-arn = aws_iam_role.ecs-task-exec-role.arn
  })
}

resource "aws_iam_user_policy_attachment" "attach-deployment-policy" {
  user       = aws_iam_user.deployer.name
  policy_arn = aws_iam_policy.deployment-policy.arn
}