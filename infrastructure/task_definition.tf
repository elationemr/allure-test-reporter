resource "aws_ecs_task_definition" "service" {
  family                   = "${local.project}-${local.workspace.environment}-${local.service_key}"
  container_definitions    = file("container-definitions-${local.workspace.environment}.json")
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.instance_role.arn
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  network_mode             = "awsvpc"
  tags                     = local.default_tags
  lifecycle {
    ignore_changes = [memory, cpu]
  }
}
