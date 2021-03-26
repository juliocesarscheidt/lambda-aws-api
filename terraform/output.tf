output aws_lambda_function {
  value = aws_lambda_function.lambda_function
}

output aws_api_gateway_deployment {
  value = aws_api_gateway_deployment.gateway_deployment
}

output "base_url" {
  value = aws_api_gateway_deployment.gateway_deployment.invoke_url
}
