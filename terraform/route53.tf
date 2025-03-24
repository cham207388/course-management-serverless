data "aws_route53_zone" "primary" {
  name = "alhagiebaicham.com"
}

resource "aws_route53_record" "couse_be_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "coursebe.alhagiebaicham.com"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.custom_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_domain.regional_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_api_gateway_domain_name.custom_domain]
}