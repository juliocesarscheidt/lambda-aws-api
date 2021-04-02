resource "aws_lambda_function" "lambda-function" {
  function_name = "lambda-function"

  # The bucket name as created earlier with "aws s3api create-bucket"
  # s3_bucket = "terraform-serverless-example"
  # s3_key    = "v1.0.0/example.zip"

  filename         = "app.zip"
  source_code_hash = filebase64sha256("app.zip")

  handler = "main.handler"
  runtime = "python3.6"
  # publish = false

  role = aws_iam_role.lambda-iam-role.arn

  environment {
    variables = {
      API_SECRET_TOKEN = var.api_secret_token
    }
  }

  vpc_config {
    subnet_ids         = aws_subnet.main-subnets.*.id
    security_group_ids = [aws_security_group.lambda-function-sg.id]
  }

  depends_on = [
    aws_security_group.lambda-function-sg
  ]
}

# permission for API gateway to invoke Lambda Function
resource "aws_lambda_permission" "api-gateway-permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest-api.execution_arn}/*/*"
}
