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

# ECS Worker memory
#app_cpu = 
#app_memory =

#beat_cpu =
#beat_memory =

#flower_cpu =
#flower_memory =

#processing_worker_cpu =
#processing_worker_memory = 

# Redis
redis_node_type = "cache.t3.micro"

# Optional extra tags
tags = {
  Owner = "dev-team"
}
