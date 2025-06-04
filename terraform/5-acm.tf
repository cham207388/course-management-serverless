# ACM Certificate
resource "aws_acm_certificate" "main" {
  domain_name               = local.frontend_domain
  subject_alternative_names = [local.api_domain]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
