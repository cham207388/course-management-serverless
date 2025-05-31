output "aws_region" {
  description = "Region where the stack is deployed"
  value       = var.aws_region
}

output "frontend_bucket" {
  description = "S3 Bucket used for frontend deployment"
  value       = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution used for frontend hosting"
  value       = aws_cloudfront_distribution.frontend_cdn.id
}

output "frontend_url" {
  description = "URL to access the React frontend"
  value       = "https://${var.frontend_url}"
}

output "api_invoke_url" {
  description = "Default API Gateway endpoint (not used in production)"
  value       = "https://${aws_api_gateway_rest_api.course_management.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}

# ───────────────────────────────────────────────
# 🔐 Cognito Outputs for Frontend Integration
# ───────────────────────────────────────────────

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID (used for JWT verification)"
  value       = aws_cognito_user_pool.course_user_pool.id
}

output "cognito_user_pool_client_id" {
  description = "Cognito App Client ID (used in frontend login)"
  value       = aws_cognito_user_pool_client.course_user_client.id
}

output "cognito_user_pool_arn" {
  description = "User Pool ARN (used by API Gateway authorizer)"
  value       = aws_cognito_user_pool.course_user_pool.arn
}

output "cognito_domain" {
  description = "Cognito domain prefix (used internally)"
  value       = aws_cognito_user_pool_domain.this.domain
}

output "cognito_domain_url" {
  description = "Full Cognito Hosted UI domain URL"
  value       = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "cognito_authorizer_issuer_url" {
  description = "Issuer URL used for JWT validation (matches JWT token's iss)"
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.course_user_pool.id}"
}

# ───────────────────────────────────────────────
# 📤 Custom Domain Output
# ───────────────────────────────────────────────

output "course_backend_url" {
  value = "https://${aws_api_gateway_domain_name.custom_domain.domain_name}"
}