# Enhanced Lambda Configuration
resource "aws_lambda_function" "course_backend" {
  function_name    = "course-backend"
  filename         = "${path.module}/../backend-ald/target/backend-ald-1.0.0-lambda-package.zip"
  source_code_hash = filebase64sha256("${path.module}/../backend-ald/target/backend-ald-1.0.0-lambda-package.zip")
  handler          = "com.abc.serverless.StreamLambdaHandler::handleRequest"
  runtime          = "java21"
  memory_size      = 1024 # Increased for Java runtime
  timeout          = 25   # Less than API Gateway's 29s limit
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      JAVA_TOOL_OPTIONS = "-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy.lambda_dynamodb
  ]
}

# Lambda Permission with explicit source ARN
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.course_backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.course_api.execution_arn}/*/*"
}