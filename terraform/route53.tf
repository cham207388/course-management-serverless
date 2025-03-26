# backend
resource "aws_route53_record" "couse_be_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "coursebe.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.custom_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_domain.regional_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_api_gateway_domain_name.custom_domain]
}

# frontend
resource "aws_route53_record" "frontend_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.frontend_url
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}