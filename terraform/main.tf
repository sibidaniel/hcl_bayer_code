terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-1331"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    assume_role = {
      role_arn = ""
    }
  }
}