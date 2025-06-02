locals {
  allowed_origin = "https://course.alhagiebaicham.com"
}

resource "aws_api_gateway_rest_api" "course_management" {
  name               = "course-management"
  description        = "REST API for Spring Boot Lambda"
  binary_media_types = ["*/*"]
}

# Catch-all route: /{proxy+}
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  parent_id   = aws_api_gateway_rest_api.course_management.root_resource_id
  path_part   = "{proxy+}"
}

# 🔐 Cognito Authorizer (must be defined before methods that use it)
resource "aws_api_gateway_authorizer" "cognito" {
  name            = "course-cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.course_management.id
  type            = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.course_user_pool.arn]
}

# 🔓 OPTIONS Method for /{proxy+}
resource "aws_api_gateway_method" "options_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_proxy" {
  rest_api_id          = aws_api_gateway_rest_api.course_management.id
  resource_id          = aws_api_gateway_resource.proxy.id
  http_method          = aws_api_gateway_method.options_proxy.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_proxy.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Access-Control-Max-Age"           = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_proxy_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_proxy.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods"     = "'OPTIONS,GET,POST,PUT,PATCH,DELETE,HEAD'"
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
  }

  depends_on = [aws_api_gateway_integration.options_proxy]
}

# 🔓 OPTIONS Method for root `/`
resource "aws_api_gateway_method" "options_root" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  resource_id   = aws_api_gateway_rest_api.course_management.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_root" {
  rest_api_id          = aws_api_gateway_rest_api.course_management.id
  resource_id          = aws_api_gateway_rest_api.course_management.root_resource_id
  http_method          = aws_api_gateway_method.options_root.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options_root_200" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_rest_api.course_management.root_resource_id
  http_method = aws_api_gateway_method.options_root.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Access-Control-Max-Age"           = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_root_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_rest_api.course_management.root_resource_id
  http_method = aws_api_gateway_method.options_root.http_method
  status_code = aws_api_gateway_method_response.options_root_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods"     = "'OPTIONS,GET,POST,PUT,PATCH,DELETE,HEAD'"
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
  }

  depends_on = [aws_api_gateway_integration.options_root]
}

# 🔐 ANY method for /{proxy+} (this will handle all methods)
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "proxy_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.course_management.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_management.invoke_arn
}

# Add CORS headers to the Lambda integration responses
resource "aws_api_gateway_method_response" "proxy_200" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  depends_on = [aws_api_gateway_integration.proxy_lambda]
}

# Error responses (4xx and 5xx)
resource "aws_api_gateway_method_response" "proxy_4xx" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "400"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_integration_response_4xx" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy_4xx.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  selection_pattern = "4\\d{2}"
  depends_on        = [aws_api_gateway_integration.proxy_lambda]
}

resource "aws_api_gateway_method_response" "proxy_5xx" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "500"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_integration_response_5xx" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy_5xx.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'${local.allowed_origin}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  selection_pattern = "5\\d{2}"
  depends_on        = [aws_api_gateway_integration.proxy_lambda]
}

# 🚀 Deployment & Stage
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id

  triggers = {
    redeploy_hash = sha1(jsonencode([
      aws_api_gateway_resource.proxy,
      aws_api_gateway_method.proxy,
      aws_api_gateway_method.options_proxy,
      aws_api_gateway_method.options_root,
      aws_api_gateway_integration.proxy_lambda,
      aws_api_gateway_integration.options_proxy,
      aws_api_gateway_integration.options_root,
      aws_api_gateway_authorizer.cognito
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_method.options_proxy,
    aws_api_gateway_method.options_root,
    aws_api_gateway_integration.proxy_lambda,
    aws_api_gateway_integration.options_proxy,
    aws_api_gateway_integration.options_root
  ]
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "dev"

  # Enable CloudWatch logging
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      requestId               = "$context.requestId",
      ip                      = "$context.identity.sourceIp",
      caller                  = "$context.identity.caller",
      user                    = "$context.identity.user",
      requestTime             = "$context.requestTime",
      httpMethod              = "$context.httpMethod",
      resourcePath            = "$context.resourcePath",
      status                  = "$context.status",
      protocol                = "$context.protocol",
      responseLength          = "$context.responseLength",
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.course_management.id}/dev"
  retention_in_days = 7
}

# 🌍 Custom Domain
resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name              = var.api_domain_name
  regional_certificate_arn = aws_acm_certificate.api.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [aws_acm_certificate_validation.api]
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
  api_id      = aws_api_gateway_rest_api.course_management.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
}

# Certificate for API Gateway
resource "aws_acm_certificate" "api" {
  domain_name       = var.api_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_acm_certificate.api.domain_validation_options : record.resource_record_name]
}
