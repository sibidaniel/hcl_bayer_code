provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/devops-role"
  }
}