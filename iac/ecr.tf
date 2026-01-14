resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge({ Name = var.ecr_repo_name }, local.common_tags)
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_lifecycle" {
  repository = aws_ecr_repository.app_ecr_repo.name
  policy     = <<POLICY
{
  "rules": [
    {"rulePriority": 1, "description": "Keep last 5 images", 
    "selection": {"tagStatus": "any", "countNumber": 5, "countType": "imageCountMoreThan"}, 
    "action": {"type": "expire"}
    }
  ]
}
POLICY
}