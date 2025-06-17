resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_execution_role.arn
  description   = "My Lambda function using a container image"
  package_type  = "Image"
  vpc_config {
    security_group_ids = [aws_security_group.public_sg.id]
    subnet_ids         = aws_subnet.public[*].id
  }
  tracing_config {
    mode = "Active"
  }
  image_uri     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/my-lambda-image:v1.0"
  timeout       = 30
  memory_size   = 256

  environment {
    variables = {
      FUNCTION_NAME = "my_lambda_function"
    }
  }
  image_config {
    command = ["index.handler"]
    
  }

  tags = {
    Name        = "My Lambda Function"
    Environment = "Dev"
  }
}
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "logs.amazonaws.com"

  source_arn = aws_cloudwatch_log_group.lambda_log_group.arn
}