variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  description = "domain name"
  default     = "alhagiebaicham.com"
}

variable "frontend_url" {
  default = "course.alhagiebaicham.com"
}

variable "api_domain_name" {
  description = "The domain name for the API Gateway"
  type        = string
  default     = "coursebe.alhagiebaicham.com"
}