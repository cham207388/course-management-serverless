output "api_invoke_url" {
  description = "Base URL to access the deployed API"
  value       = "https://${aws_api_gateway_rest_api.course_management.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev_stage.stage_name}"
}

output "api_custom_domain_url" {
  description = "Base URL for your API using custom domain"
  value       = "https://${aws_api_gateway_domain_name.custom_domain.domain_name}"
}

# output "swagger_ui_url" {
#   description = "Swagger UI for the deployed API"
#   value       = "https://${aws_api_gateway_domain_name.custom_domain.domain_name}/swagger-ui/index.html"
# }