variable "aws_region" {
  default = "us-east-1"
}

variable "acm_certificate_arn" {
  description = "The ACM certificate ARN for custom domain in us-east-1"
  type        = string
}

variable "acm_cert_arn_agw" {
  description = "The ACM certificate ARN for api gateway"
  type        = string
}

variable "domain_name" {
  description = "domain name"
}

variable "frontend_url" {
  default = "course.alhagiebaicham.com"
}