resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_cognito_user_pool" "course_user_pool" {
  name = "course-user-pool"

  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]

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

  admin_create_user_config {
    allow_admin_create_user_only = false
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

  callback_urls = [var.frontend_url]
  logout_urls   = [var.frontend_url]
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "course-auth-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.course_user_pool.id
}
