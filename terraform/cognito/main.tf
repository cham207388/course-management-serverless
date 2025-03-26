resource "aws_cognito_user_pool" "course_user_pool" {
  name = "course-user-pool"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "course_user_client" {
  name         = "course-client"
  user_pool_id = aws_cognito_user_pool.course_user_pool.id

  generate_secret                      = false
  prevent_user_existence_errors        = "ENABLED"
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  callback_urls = ["https://course.alhagiebaicham.com"]
  logout_urls   = ["https://course.alhagiebaicham.com"]
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.course_user_pool.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.course_user_client.id
}