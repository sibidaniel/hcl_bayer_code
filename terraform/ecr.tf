resource "aws_ecr_repository" "my_docker_image" {
  name = "my-lambda-image"

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "My Docker Image Repository"
    Environment = "Dev"
  }
}
resource "aws_ecr_lifecycle_policy" "my_docker_image_lifecycle" {
  repository = aws_ecr_repository.my_docker_image.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 30 days"
        selection    = {
          tagStatus = "untagged"
          countType = "sinceImagePushed"
          countUnit = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
resource "aws_ecr_repository_policy" "my_docker_image_policy" {
  repository = aws_ecr_repository.my_docker_image.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}