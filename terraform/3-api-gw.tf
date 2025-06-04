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

# Enable CORS for all methods
module "cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.course_api.id
  api_resource_id = aws_api_gateway_resource.proxy.id

  allow_origin = "'https://course.alhagiebaicham.com'"
  allow_headers = [
    "'Content-Type'",
    "'X-Amz-Date'",
    "'Authorization'",
    "'X-Api-Key'",
    "'X-Amz-Security-Token'",
    "'X-Requested-With'"
  ]
  allow_methods     = ["'GET'", "'POST'", "'PUT'", "'DELETE'", "'OPTIONS'"]
  allow_credentials = true
}

# Regular API Methods
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_backend.invoke_arn
}

# Root resource configuration
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_backend.invoke_arn
}

# Deployment
resource "aws_api_gateway_deployment" "course_api" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
    module.cors
  ]

  rest_api_id = aws_api_gateway_rest_api.course_api.id
  description = "Course API deployment"

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.lambda,
      aws_api_gateway_integration.lambda_root,
      module.cors
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
