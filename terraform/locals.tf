locals {
  api_gateway_domain     = split("/${var.api_stage}", replace(aws_api_gateway_deployment.api-gateway-deployment.invoke_url, "https://", ""))[0]
  api_gateway_stage_path = "/${var.api_stage}"
  api_fqdn               = "todoapp.onaws.${var.root_domain}"
  cloudfront_origin_id   = "lambda-function-${random_string.random.result}"
}
