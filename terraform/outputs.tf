output "api_invoke_url" {
  description = "Base URL to access the deployed API"
  value       = "https://${aws_api_gateway_rest_api.course_management.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev_stage.stage_name}"
}

output "api_custom_domain_url" {
  description = "Base URL for your API using custom domain"
  value       = "https://${aws_api_gateway_domain_name.custom_domain.domain_name}"
}

output "frontend_url" {
  value = "https://${var.frontend_url}"
}

output "frontend_bucket" {
  value = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend_cdn.id
}