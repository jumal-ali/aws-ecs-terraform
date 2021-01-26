output "app-load-balancer" {
  value = aws_alb.ecs-alb.dns_name
}

output "ecs-task-exec-role" {
  value = aws_iam_role.ecs-task-exec-role.name
}

output "ci-deployer-bot-name" {
  value = aws_iam_user.deployer.name
}