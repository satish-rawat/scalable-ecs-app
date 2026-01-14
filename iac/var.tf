variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "scalable-parrallel-processer"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use (optional)"
  type        = string
  default     = "default"
}

variable "azs" {
  description = "List of AZs to use for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "scalable-parrallel-processer-app"
}

variable "image_tag" {
  description = "Image tag to use for deployments"
  type        = string
  default     = "latest"
}

variable "container_api_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "container_flower_port" {
  description = "Port the container listens on"
  type        = number
  default     = 5555
}

variable "desired_count" {
  description = "ECS service desired task count"
  type        = number
  default     = 1
}

variable "min_tasks" {
  description = "Minimum number of tasks for autoscaling"
  type        = number
  default     = 1
}

variable "max_tasks" {
  description = "Maximum number of tasks for autoscaling"
  type        = number
  default     = 4
}

variable "fargate_cpu" {
  description = "Fargate task CPU units"
  type        = string
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate task memory (MiB)"
  type        = string
  default     = "512"
}

variable "redis_node_type" {
  description = "ElastiCache node type for Redis (dev)"
  type        = string
  default     = "cache.t3.micro"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention days"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}