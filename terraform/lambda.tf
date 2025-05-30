resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.devops_role.arn
  handler       = "index.handler"
  runtime       = "container-image"
  image_uri     = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-lambda-image:latest"
  timeout       = 30
  memory_size   = 256

  environment {
    variables = {
      ENV_VAR1 = "value1"
      ENV_VAR2 = "value2"
    }
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