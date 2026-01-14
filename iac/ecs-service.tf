resource "aws_ecs_cluster" "app_cluster" {
  name = "${local.name_prefix}-ecs"
  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.project_name}-${var.environment}/app_log_group"
  retention_in_days = var.log_retention_days
  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "flower_log_group" {
  name              = "/ecs/${var.project_name}-${var.environment}/flower_log_group"
  retention_in_days = var.log_retention_days
  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "beat_log_group" {
  name              = "/ecs/${var.project_name}-${var.environment}/beat_log_group"
  retention_in_days = var.log_retention_days
  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "processor_log_group" {
  name              = "/ecs/${var.project_name}-${var.environment}/processor_log_group"
  retention_in_days = var.log_retention_days
  tags = local.common_tags
}

resource "aws_ecs_service" "app_api_service" {
  name            = "${var.project_name}-${var.environment}-svc"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_api_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = aws_subnet.private.*.id
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_load_balancer.arn
    container_name   = "${var.project_name}-container"
    container_port   = var.container_app_port
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  tags = local.common_tags
  depends_on = [aws_lb_listener.app_listener]
}

resource "aws_ecs_service" "app_flower_service" {
  name            = "${var.project_name}-${var.environment}-svc"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_flower_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = aws_subnet.private.*.id
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_load_balancer.arn
    container_name   = "${var.project_name}-container"
    container_port   = var.container_flower_port
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  tags = local.common_tags
  depends_on = [aws_lb_listener.app_listener]
}

resource "aws_ecs_service" "app_beat_service" {
  name            = "${var.project_name}-${var.environment}-svc"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_beat_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = aws_subnet.private.*.id
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }


  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  tags = local.common_tags
}

resource "aws_ecs_service" "app_processing_service" {
  name            = "${var.project_name}-${var.environment}-svc"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_processing_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = aws_subnet.private.*.id
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }


  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  tags = local.common_tags
}