## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.92.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_base_path_mapping.mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.api_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.custom_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_integration.lambda_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.any_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.course_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.dev_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudfront_distribution.frontend_cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_dynamodb_table.course_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.lambda_dynamodb_crud_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_dynamodb_crud_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.course_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_apigw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.couse_be_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.frontend_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.public_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | The ACM certificate ARN for custom domain in us-east-1 | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-2"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | domain name | `any` | n/a | yes |
| <a name="input_frontend_url"></a> [frontend\_url](#input\_frontend\_url) | n/a | `string` | `"course.alhagiebaicham.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_url"></a> [api\_custom\_domain\_url](#output\_api\_custom\_domain\_url) | Base URL for your API using custom domain |
| <a name="output_api_invoke_url"></a> [api\_invoke\_url](#output\_api\_invoke\_url) | Base URL to access the deployed API |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | n/a |
| <a name="output_frontend_bucket"></a> [frontend\_bucket](#output\_frontend\_bucket) | n/a |
| <a name="output_frontend_url"></a> [frontend\_url](#output\_frontend\_url) | n/a |
