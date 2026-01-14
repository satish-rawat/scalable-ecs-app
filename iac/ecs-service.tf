resource "aws_ecs_cluster" "this" {
  name = "${local.name_prefix}-ecs"
  tags = local.common_tags
}

# CloudWatch Log Group for the app (moved from main.tf)
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = var.log_retention_days
  tags = local.common_tags
}

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-${var.environment}-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = aws_subnet.private.*.id
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.project_name}-container"
    container_port   = var.container_port
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  tags = local.common_tags
  depends_on = [aws_lb_listener.http]
}
