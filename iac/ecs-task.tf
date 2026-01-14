resource "aws_ecs_task_definition" "app_api_task_def" {
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-container"
      image = "${aws_ecr_repository.app_ecr_repo.repository_url}:${var.image_tag}"
      portMappings = [
        { containerPort = var.container_api_port, hostPort = var.container_api_port, protocol = "tcp" }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "WORKER_TYPE", value = "app" },
        { name = "ENV", value = var.environment },
        { name = "REDIS_ENDPOINT", value = aws_elasticache_replication_group.app_redis.primary_endpoint_address }
      ]
    }
  ])
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "app_flower_task_def" {
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-container"
      image = "${aws_ecr_repository.app_ecr_repo.repository_url}:${var.image_tag}"
      portMappings = [
        { containerPort = var.container_flower_port, hostPort = var.container_flower_port, protocol = "tcp" }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.flower_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "WORKER_TYPE", value = "flower_worker" },
        { name = "ENV", value = var.environment },
        { name = "REDIS_ENDPOINT", value = aws_elasticache_replication_group.app_redis.primary_endpoint_address }
      ]
    }
  ])
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "app_beat_task_def" {
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-container"
      image = "${aws_ecr_repository.app_ecr_repo.repository_url}:${var.image_tag}"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.beat_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "WORKER_TYPE", value = "beat_worker" },
        { name = "ENV", value = var.environment },
        { name = "REDIS_ENDPOINT", value = aws_elasticache_replication_group.app_redis.primary_endpoint_address }
      ]
    }
  ])
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "app_processing_task_def" {
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-container"
      image = "${aws_ecr_repository.app_ecr_repo.repository_url}:${var.image_tag}"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.processor_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "WORKER_TYPE", value = "processing_worker" },
        { name = "ENV", value = var.environment },
        { name = "REDIS_ENDPOINT", value = aws_elasticache_replication_group.app_redis.primary_endpoint_address }
      ]
    }
  ])
  tags = local.common_tags
}