# Outputs

output "frontend_bucket" {
  description = "S3 Bucket used for frontend deployment"
  value       = aws_s3_bucket.frontend.bucket
}
output "frontend_url" {
  value = "https://${local.frontend_domain}"
}

output "api_url" {
  value = "https://${local.api_domain}"
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.users.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.web_client.id
}

output "cognito_domain" {
  value = "${aws_cognito_user_pool_domain.auth.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "aws_region" {
  value = var.aws_region
}

output "api_invoke_url" {
  description = "Default API Gateway endpoint (not used in production)"
  value       = "https://${aws_api_gateway_rest_api.course_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}"
}

output "cognito_user_pool_client_id" {
  description = "Cognito App Client ID (used in frontend login)"
  value       = aws_cognito_user_pool_client.web_client.id
}

output "cognito_domain_url" {
  description = "Cognito Domain URL"
  value       = "https://${aws_cognito_user_pool_domain.auth.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "cognito_authorizer_issuer_url" {
  description = "Issuer URL used for JWT validation (matches JWT token's iss)"
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.users.id}"
}

output "course_backend_url" {
  value = "https://${aws_api_gateway_domain_name.api.domain_name}"
}