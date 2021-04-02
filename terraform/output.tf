output aws_lambda_function {
  value = aws_lambda_function.lambda-function
}

output aws_api_gateway_deployment {
  value = aws_api_gateway_deployment.api-gateway-deployment
}

output "base_url" {
  value = aws_api_gateway_deployment.api-gateway-deployment.invoke_url
}
