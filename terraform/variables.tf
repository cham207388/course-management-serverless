variable "aws_region" {
  default = "us-east-2"
}

variable "acm_certificate_arn" {
  description = "The ACM certificate ARN for custom domain in us-east-1"
  type        = string
}

variable "domain_name" {
  description = "domain name"
}