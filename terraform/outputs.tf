output "aws_region" {
  value = var.aws_region
}
output "api_invoke_url" {
  description = "Base URL to access the deployed API"
  value       = "https://${aws_api_gateway_rest_api.course_management.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}

output "backend_url" {
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

# ---------------------
# Outputs
# ---------------------
# ✅ User Pool ID (used in frontend and backend API validation)
output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.course_user_pool.id
}

# ✅ User Pool ARN (used in API Gateway authorizer configuration)
output "cognito_user_pool_arn" {
  description = "Cognito User Pool ARN"
  value       = aws_cognito_user_pool.course_user_pool.arn
}

# ✅ App Client ID (used by frontend for login)
output "cognito_user_pool_client_id" {
  description = "Cognito App Client ID"
  value       = aws_cognito_user_pool_client.course_user_client.id
}

# ✅ Hosted UI domain (root domain only)
output "cognito_domain" {
  description = "Cognito domain prefix (not full URL)"
  value       = aws_cognito_user_pool_domain.this.domain
}

# ✅ Full Hosted UI Domain URL (used in frontend for OAuth redirect/login)
output "cognito_domain_url" {
  description = "Full Cognito Hosted UI domain URL"
  value       = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}

# ✅ Issuer URL used for JWT validation in API Gateway
output "cognito_authorizer_issuer_url" {
  description = "Cognito Issuer URL for API Gateway JWT validation"
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.course_user_pool.id}"
}