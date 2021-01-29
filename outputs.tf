output "app-load-balancer" {
  value = aws_alb.ecs-alb.dns_name
}

output "task-update-info" {
  value = [for k, v in var.containers : {
    Task : aws_ecs_task_definition.ecs-task[v.app-name].family,
    Role : aws_iam_role.ecs-task-exec-role[v.app-name].name
    Service : aws_ecs_service.ecs-service[v.app-name].name,
    Cluster : aws_ecs_cluster.ecs.name
  }]
}

output "ci-deployer-bot-name" {
  value = aws_iam_user.deployer.name
}

output "bastion-public-ip" {
  value = var.create-bastion ? aws_instance.bastion[0].public_ip : "Bastion Not Created"
}