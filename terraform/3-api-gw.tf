# API Gateway (REST API)
resource "aws_api_gateway_rest_api" "course_api" {
  name        = "course-api"
  description = "API for Course Backend"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  path_part   = "{proxy+}"
}

# CORS Configuration for OPTIONS method
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,POST,PUT,DELETE,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"      = "'https://course.alhagiebaicham.com'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  depends_on = [aws_api_gateway_integration.options]
}

# Regular API Methods with CORS headers
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "proxy_200" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_backend.invoke_arn
}

resource "aws_api_gateway_integration_response" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'https://course.alhagiebaicham.com'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  depends_on = [aws_api_gateway_integration.lambda]
}

# Root resource configuration
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "proxy_root_200" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_rest_api.course_api.root_resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_backend.invoke_arn
}

resource "aws_api_gateway_integration_response" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_rest_api.course_api.root_resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method
  status_code = aws_api_gateway_method_response.proxy_root_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'https://course.alhagiebaicham.com'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  depends_on = [aws_api_gateway_integration.lambda_root]
}

resource "aws_api_gateway_deployment" "course_api" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
    aws_api_gateway_integration.options,
    aws_api_gateway_integration_response.lambda,
    aws_api_gateway_integration_response.lambda_root,
    aws_api_gateway_integration_response.options
  ]

  rest_api_id = aws_api_gateway_rest_api.course_api.id
  description = "Course API deployment"

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.lambda,
      aws_api_gateway_integration.lambda_root,
      aws_api_gateway_integration.options
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  deployment_id = aws_api_gateway_deployment.course_api.id
}

# API Gateway Custom Domain
resource "aws_api_gateway_domain_name" "api" {
  domain_name              = local.api_domain
  regional_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [aws_acm_certificate_validation.cert]
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.course_api.id
  stage_name  = aws_api_gateway_stage.prod.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}