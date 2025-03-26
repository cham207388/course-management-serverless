resource "aws_api_gateway_rest_api" "course_management" {
  name        = "course-management"
  description = "REST API for Spring Boot Lambda"

  # meant to resolve swagger
  binary_media_types = [
    "application/octet-stream",
    "application/javascript",
    "application/json",
    "application/xml",
    "text/html",
    "text/css",
    "text/plain",
    "image/png",
    "image/jpeg",
    "*/*"
  ]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id
  parent_id   = aws_api_gateway_rest_api.course_management.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "any_method" {
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.course_management.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.any_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_management.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.course_management.id

  triggers = {
    redeployment = sha1(jsonencode({
      lambda_version = aws_lambda_function.course_management.source_code_hash
    }))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_integration.lambda_proxy]
}

resource "aws_api_gateway_stage" "dev_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.course_management.id
  stage_name    = "dev"
  description   = "Development stage"
}

# custom domain and mapping
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
  stage_name  = aws_api_gateway_stage.dev_stage.stage_name
}