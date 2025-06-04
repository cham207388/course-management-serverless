data "aws_caller_identity" "current" {}

data "aws_route53_zone" "primary" {
  name = "${var.domain_name}."
}