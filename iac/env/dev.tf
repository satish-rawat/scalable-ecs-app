project_name = "scalable-parrallel-processer"
environment  = "dev"
aws_region   = "us-east-1"
aws_profile  = "default"

# App settings
ecr_repo_name = "devops-pocs-app"
image_tag     = "latest"

# ECS / Autoscaling
desired_count = 1
min_tasks     = 1
max_tasks     = 3

# Redis
redis_node_type = "cache.t3.micro"

# Optional extra tags
tags = {
  Owner = "dev-team"
}
