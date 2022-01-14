data "aws_ssm_parameter" "caregaps_service_sg_id" {
  name = "/el8/caregaps/${local.workspace.environment}/service_security_group/id"
}

resource "aws_ecs_service" "ecs_service" {
  name    = "${local.project}-${local.workspace.environment}-${local.service_key}"
  cluster = local.workspace.cluster

  desired_count = local.workspace.desired_tasks

  launch_type = "FARGATE"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  task_definition = aws_ecs_task_definition.service.arn

  depends_on = [
    aws_iam_role.instance_role
  ]

  network_configuration {
    subnets          = local.workspace.private_subnets
    security_groups  = [data.aws_ssm_parameter.caregaps_service_sg_id.value]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_service_lb_tg.arn
    container_name   = "service"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }

  tags = local.default_tags
}
