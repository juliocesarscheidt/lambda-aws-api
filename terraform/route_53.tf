data "aws_route53_zone" "root_zone" {
  name = "${var.root_domain}."

  depends_on = [aws_cloudfront_distribution.api-gateway-distribution]
}

resource "aws_route53_record" "a_record" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.root_zone.zone_id
  name            = local.api_fqdn
  type            = "A"

  alias {
    name                   = aws_cloudfront_distribution.api-gateway-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.api-gateway-distribution.hosted_zone_id
    evaluate_target_health = false
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_cloudfront_distribution.api-gateway-distribution
  ]
}
