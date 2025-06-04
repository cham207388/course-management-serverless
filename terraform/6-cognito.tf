resource "random_id" "suffix" {
  byte_length = 4
}

# Cognito User Pool
resource "aws_cognito_user_pool" "users" {
  name                     = "course-users"
  username_attributes      = ["email"]
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

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

resource "aws_cognito_user_pool_client" "web_client" {
  name         = "web-client"
  user_pool_id = aws_cognito_user_pool.users.id

  generate_secret = false

  callback_urls                = ["https://${local.frontend_domain}", "http://localhost:5173"]
  logout_urls                  = ["https://${local.frontend_domain}", "http://localhost:5173"]
  default_redirect_uri         = "https://${local.frontend_domain}"
  supported_identity_providers = ["COGNITO"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_domain" "auth" {
  domain       = "auth-${local.sanitized_domain}-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.users.id
}