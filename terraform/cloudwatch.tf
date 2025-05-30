resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/my_lambda_function"
  retention_in_days = 14

  tags = {
    Name        = "Lambda Log Group"
    Environment = "Dev"
  }
}
resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = "my_lambda_function_stream"
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
}
