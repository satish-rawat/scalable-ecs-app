resource "aws_security_group" "alb" {
  name   = "${var.project_name}-${var.environment}-alb-sg"
  vpc_id = aws_vpc.this.id
  description = "Allow HTTP inbound"
  ingress = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  ]
  egress = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] },
  ]
  tags = local.common_tags
}

resource "aws_security_group" "ecs_tasks" {
  name   = "${var.project_name}-${var.environment}-ecs-sg"
  vpc_id = aws_vpc.this.id
  description = "Allow traffic from ALB and to Redis"
  ingress = [
    { from_port = var.container_port, to_port = var.container_port, protocol = "tcp", security_groups = [aws_security_group.alb.id] },
  ]
  egress = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] },
  ]
  tags = local.common_tags
}

resource "aws_security_group" "redis" {
  name   = "${var.project_name}-${var.environment}-redis-sg"
  vpc_id = aws_vpc.this.id
  description = "Allow access from ECS tasks only"
  ingress = [
    { from_port = 6379, to_port = 6379, protocol = "tcp", security_groups = [aws_security_group.ecs_tasks.id] },
  ]
  egress = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] },
  ]
  tags = local.common_tags
}