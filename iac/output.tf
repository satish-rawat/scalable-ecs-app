output "ecr_repo_uri" {
  value = aws_ecr_repository.app.repository_url
  description = "ECR repository URI (without tag)"
}

output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "ALB DNS name"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
  description = "Redis primary endpoint address"
}