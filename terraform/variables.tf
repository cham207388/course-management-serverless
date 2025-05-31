variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "domain name"
  default     = "alhagiebaicham.com"
}

variable "frontend_url" {
  description = "Frontend domain name"
  default     = "course.alhagiebaicham.com"
}

variable "api_domain_name" {
  description = "The domain name for the API Gateway"
  type        = string
  default     = "api.alhagiebaicham.com"
}