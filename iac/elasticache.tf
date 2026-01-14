resource "aws_elasticache_subnet_group" "app_redis" {
  name       = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids = aws_subnet.private.*.id
  tags = local.common_tags
}

resource "aws_elasticache_replication_group" "app_redis_rep_group" {
  replication_group_id          = "${var.project_name}-${var.environment}-redis"
  replication_group_description = "Redis for ${var.project_name}-${var.environment}"
  engine                        = "redis"
  engine_version                = "6.x"
  node_type                     = var.redis_node_type
  number_cache_clusters         = 1
  automatic_failover_enabled    = false
  subnet_group_name             = aws_elasticache_subnet_group.redis.name
  security_group_ids            = [aws_security_group.redis.id]
  tags = local.common_tags
}