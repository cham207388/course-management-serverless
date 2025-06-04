variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "domain name"
}

variable "frontend_domain_name" {
  description = "Frontend domain name"
}
variable "api_subdomain" {
  description = "API subdomain"
  type        = string
  default     = "api"
}

variable "frontend_subdomain" {
  description = "Frontend subdomain"
  type        = string
  default     = "course"
}

variable "api_domain_name" {
  description = "The domain name for the API Gateway"
  type        = string
}