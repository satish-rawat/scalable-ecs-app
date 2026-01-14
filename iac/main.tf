terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge({
    Project = var.project_name
    Env     = var.environment
  }, var.tags)
}

# VPC and networking configuration moved to `vpc.tf`
# ECS cluster and CloudWatch Log Group moved to `ecs-service.tf`

# Outputs have been moved to `output.tf` to keep things organized
