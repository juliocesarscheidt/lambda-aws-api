output lambda_function_arn {
  value = aws_lambda_function.lambda-function.arn
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.api-gateway-deployment.invoke_url
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.api-gateway-distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.api-gateway-distribution.hosted_zone_id
}

output "api_fqdn" {
  value = local.api_fqdn
}
