# Outputs
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