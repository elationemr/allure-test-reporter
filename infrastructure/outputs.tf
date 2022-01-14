# This is a naive example of how we could output variables and use them
# in GH Actions. In this case docs are uploaded. Most common use case
# would probably be to upload task definitions to ECS for services.

output "task_definition_arn" {
  value = aws_ecs_task_definition.service.arn
}

output "cluster_name" {
  value = aws_ecs_service.ecs_service.cluster
}

# output "service_name" {
#   value = aws_ecs_service.ecs_service.name
# }
