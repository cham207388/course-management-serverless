# ───────────────────────────────────────────────
# 🛠 API Gateway Configuration
# ───────────────────────────────────────────────

locals {
  allowed_origin = "https://course.alhagiebaicham.com"
}

# ───────────────────────────────────────────────
# API Gateway REST API
# ───────────────────────────────────────────────

resource "aws_api_gateway_rest_api" "course_management" {
  name               = "course-management"
  description        = "REST API for Spring Boot Lambda"
  binary_media_types = ["*/*"]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  parent_id   = aws_api_gateway_rest_api.course_management.root_resource_id
  path_part   = "{proxy+}"
}

# ───────────────────────────────────────────────
# CORS Configuration (Fixed)
# ───────────────────────────────────────────────

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.course_management.id
  resource_id          = aws_api_gateway_resource.proxy.id
  http_method          = aws_api_gateway_method.options_method.http_method
  type                 = "MOCK"
  passthrough_behavior = "NEVER" # This fixes the 500 error

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Max-Age"           = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'OPTIONS,GET,PUT,POST,DELETE,PATCH,HEAD'",
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'",
    "method.response.header.Access-Control-Max-Age"           = "'7200'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  # Required empty response template
  response_templates = {
    "application/json" = jsonencode({})
  }

  depends_on = [aws_api_gateway_integration.options_integration]
}

# ───────────────────────────────────────────────
# Proxy Method Configuration
# ───────────────────────────────────────────────

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_management.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_management.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_response_200" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = aws_api_gateway_method_response.proxy_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}

# ───────────────────────────────────────────────
# Authorizer Configuration
# ───────────────────────────────────────────────

resource "aws_api_gateway_authorizer" "cognito" {
  name            = "course-cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.course_management.id
  type            = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.course_user_pool.arn]
}

# ───────────────────────────────────────────────
# Deployment Configuration
# ───────────────────────────────────────────────

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.lambda_integration,
      aws_api_gateway_integration.options_integration,
      aws_api_gateway_method.proxy_method,
      aws_api_gateway_method.options_method,
      aws_api_gateway_integration_response.options_integration_response,
      aws_api_gateway_integration_response.proxy_integration_response
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_method_response.options_response,
    aws_api_gateway_integration_response.options_integration_response,
    aws_api_gateway_method_response.proxy_response_200,
    aws_api_gateway_integration_response.proxy_integration_response,
    aws_api_gateway_authorizer.cognito
  ]
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  stage_name    = "dev"
  description   = "Development stage"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId",
      ip             = "$context.identity.sourceIp",
      requestTime    = "$context.requestTime",
      httpMethod     = "$context.httpMethod",
      resourcePath   = "$context.resourcePath",
      status         = "$context.status",
      protocol       = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }
}

# ───────────────────────────────────────────────
# Custom Domain Configuration
# ───────────────────────────────────────────────

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name              = "coursebe.alhagiebaicham.com"
  regional_certificate_arn = var.acm_cert_arn_agw

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
  api_id      = aws_api_gateway_rest_api.course_management.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
}

# ───────────────────────────────────────────────
# CloudWatch Logs Configuration
# ───────────────────────────────────────────────

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/api-gw/${aws_api_gateway_rest_api.course_management.name}"
  retention_in_days = 7
}

resource "aws_api_gateway_account" "api_gw_account" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch.arn
}

resource "aws_iam_role" "api_gw_cloudwatch" {
  name = "api-gateway-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gw_cloudwatch" {
  role       = aws_iam_role.api_gw_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}