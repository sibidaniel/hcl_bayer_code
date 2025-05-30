provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::539935451710:role/GitHubAction-AssumeRoleWithAction"
  }
}