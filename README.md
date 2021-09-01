# Terraform AWS module for AWS Lambda

## Introduction
This module creates an AWS lambda and all the related resources. It is a complete re-write of our internal terraform lambda module.

## Usage
Checkout [examples](./examples) on how to use this module for various trigger sources.
## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch-log-subscription"></a> [cloudwatch-log-subscription](#module\_cloudwatch-log-subscription) | ./log_subscription/ | n/a |
| <a name="module_triggered-by-api-gateway"></a> [triggered-by-api-gateway](#module\_triggered-by-api-gateway) | ./triggers/api_gateway/ | n/a |
| <a name="module_triggered-by-cloudwatch-event-schedule"></a> [triggered-by-cloudwatch-event-schedule](#module\_triggered-by-cloudwatch-event-schedule) | ./triggers/cloudwatch_event_schedule/ | n/a |
| <a name="module_triggered-by-cloudwatch-event-trigger"></a> [triggered-by-cloudwatch-event-trigger](#module\_triggered-by-cloudwatch-event-trigger) | ./triggers/cloudwatch_event_trigger/ | n/a |
| <a name="module_triggered-by-cloudwatch-logs"></a> [triggered-by-cloudwatch-logs](#module\_triggered-by-cloudwatch-logs) | ./triggers/cloudwatch_logs/ | n/a |
| <a name="module_triggered-by-cognito-idp"></a> [triggered-by-cognito-idp](#module\_triggered-by-cognito-idp) | ./triggers/cognito_idp/ | n/a |
| <a name="module_triggered-by-sqs"></a> [triggered-by-sqs](#module\_triggered-by-sqs) | ./triggers/sqs/ | n/a |
| <a name="module_triggered-by-step-function"></a> [triggered-by-step-function](#module\_triggered-by-step-function) | ./triggers/step_function/ | n/a |
| <a name="module_triggered_by_kinesis"></a> [triggered\_by\_kinesis](#module\_triggered\_by\_kinesis) | ./triggers/kinesis/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | Enable Cloudwatch logs retention | `number` | `90` | no |
| <a name="input_cloudwatch_log_subscription"></a> [cloudwatch\_log\_subscription](#input\_cloudwatch\_log\_subscription) | Cloudwatch log stream configuration | <pre>object({<br>    enable : bool<br>    filter_pattern : string<br>    destination_arn : string<br>  })</pre> | <pre>{<br>  "destination_arn": "",<br>  "enable": false,<br>  "filter_pattern": ""<br>}</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Lambda function description | `string` | `"Managed by Terraform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Lambda environment variables | `map(string)` | `null` | no |
| <a name="input_file_name"></a> [file\_name](#input\_file\_name) | Lambda function filename name | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda function handler | `string` | n/a | yes |
| <a name="input_kinesis_configuration"></a> [kinesis\_configuration](#input\_kinesis\_configuration) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping | <pre>map(object({<br>    batch_size                                      = number<br>    bisect_batch_on_function_error                  = bool<br>    destination_config__on_failure__destination_arn = string<br>    event_source_arn                                = string<br>    maximum_batching_window_in_seconds              = number<br>    maximum_record_age_in_seconds                   = number<br>    maximum_retry_attempts                          = number<br>    parallelization_factor                          = number<br>    starting_position                               = string<br>    starting_position_timestamp                     = string<br>    tumbling_window_in_seconds                      = number<br>  }))</pre> | `{}` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of layers for this lambda function | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Lambda function memory size | `number` | `128` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Publish lambda function | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Reserved concurrent executions  for this lambda function | `number` | `-1` | no |
| <a name="input_role"></a> [role](#input\_role) | Lambda function role | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda function runtime | `string` | `"nodejs14.x"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for this lambda function | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Lambda function runtime | `number` | `300` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | https://www.terraform.io/docs/providers/aws/r/lambda_function.html | <pre>object({<br>    mode : string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |
| <a name="input_trigger"></a> [trigger](#input\_trigger) | Trigger configuration for this lambda function | `any` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Lambda VPC configuration | <pre>object({<br>    subnet_ids : list(string)<br>    security_group_ids : list(string)<br>  })</pre> | <pre>{<br>  "security_group_ids": [],<br>  "subnet_ids": []<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | AWS lambda arn |
| <a name="output_dlq"></a> [dlq](#output\_dlq) | AWS lambda Dead Letter Queue details |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | AWS lambda function name |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | AWS lambda invoke\_arn |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | AWS lambda qualified\_arn |
| <a name="output_queue"></a> [queue](#output\_queue) | AWS lambda SQS details |
| <a name="output_sns_topics"></a> [sns\_topics](#output\_sns\_topics) | AWS lambda SNS topics if any |
| <a name="output_version"></a> [version](#output\_version) | AWS lambda version |
