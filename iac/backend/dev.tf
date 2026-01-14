# NOTE: Terraform backend configuration cannot reference variables directly. For remote state
# provide these values when you run `terraform init -backend-config="bucket=BUCKET_NAME" \
# -backend-config="key=path/to/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="dynamodb_table=TABLE_NAME"`

# Example backend block (replace placeholders or pass via -backend-config):
terraform {
  backend "s3" {
    bucket         = "application-state"
    key            = "${var.project_name}/${var.environment}/terraform.tfstate"
    region         = "${var.aws_region}"
    encrypt        = true
  }
}

# Tip: create the S3 bucket and DynamoDB table for locking before running terraform init.
# Example commands (AWS CLI):
# aws s3api create-bucket --bucket <bucket-name> --region ${var.aws_region} --create-bucket-configuration LocationConstraint=${var.aws_region}
# aws dynamodb create-table --table-name <table-name> --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
