output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.deployment.execution_arn}${aws_api_gateway_stage.dev.stage_name}"
}

output "api_gateway_custom_domain_url" {
  value = "https://${aws_api_gateway_domain_name.custom_domain.domain_name}"
}

output "frontend_url" {
  value = "https://${var.frontend_url}"
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.course_user_pool.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}