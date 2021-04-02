resource "random_string" "random" {
  length  = 16
  special = false
}

resource "aws_cloudfront_distribution" "api-gateway-distribution" {
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "API Gateway Cloud Front distribution"
  default_root_object = "/"
  wait_for_deployment = false

  origin {
    domain_name = local.api_gateway_domain
    origin_path = local.api_gateway_stage_path
    origin_id   = local.cloudfront_origin_id

    custom_origin_config {
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1"]
      http_port              = 80
      https_port             = 443
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"

    target_origin_id = local.cloudfront_origin_id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    # auth-header Cache Policy
    cache_policy_id = aws_cloudfront_cache_policy.auth-header-cache-policy.id
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "BR"]
    }
  }

  aliases = [local.api_fqdn]

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.certificate_arn
    ssl_support_method             = "sni-only"
  }

  tags = {
    Environment = var.api_stage
  }

  depends_on = [
    aws_api_gateway_deployment.api-gateway-deployment,
    aws_cloudfront_cache_policy.auth-header-cache-policy
  ]
}

resource "aws_cloudfront_cache_policy" "auth-header-cache-policy" {
  name = "auth-header-cache-policy"

  min_ttl     = 1
  max_ttl     = 31536000
  default_ttl = 86400

  parameters_in_cache_key_and_forwarded_to_origin {
    # this will allow the Distribution to forward
    # Authorization header to API Gateway, once it is used there
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Authorization"]
      }
    }

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
