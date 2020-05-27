# Terraform AWS module for AWS Lambda

## Introduction  
This module creates an AWS lambda and all the related resources. It is a complete re-write of our internal terraform lambda module and all functionality has not yet been tested.

## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch_log_retention | Enable Cloudwatch logs retention | `number` | `90` | no |
| cloudwatch_log_subscription | Cloudwatch log stream configuration | `map(string)` | `{}` | no |
| description | Lambda function description | `string` | `"Managed by Terraform"` | no |
| enable_cloudwatch_log_subscription | Enable Cloudwatch log subscription | `bool` | `false` | no |
| environment | Lambda environment variables | `map(string)` | `{}` | no |
| file_name | Lambda function filename name | `string` | n/a | yes |
| function_name | Lambda function name | `string` | n/a | yes |
| handler | Lambda function handler | `string` | n/a | yes |
| layers | List of layers for this lambda function | `list(string)` | `[]` | no |
| memory_size | Lambda function memory size | `number` | `128` | no |
| publish | Publish lambda function | `bool` | `false` | no |
| region | AWS region | `string` | n/a | yes |
| reserved_concurrent_executions | Reserved concurrent executions  for this lambda function | `number` | `-1` | no |
| role | Lambda function role | `string` | n/a | yes |
| runtime | Lambda function runtime | `string` | `"nodejs12.x"` | no |
| tags | Tags for this lambda function | `map` | `{}` | no |
| timeout | Lambda function runtime | `number` | `300` | no |
| tracing_config | https://www.terraform.io/docs/providers/aws/r/lambda_function.html | <pre>object({<br>    mode : string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |
| trigger | trigger configuration for this lambda function | `map(string)` | n/a | yes |
| vpc_config | Lambda VPC configuration | <pre>object({<br>    subnet_ids : list(string)<br>    security_group_ids : list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS lambda arn |
| dlq-arn | AWS lambda DLQ ARN |
| dlq-url | AWS lambda DLQ URL |
| invoke_arn | AWS lambda invoke_arn |
| last_modified | AWS lambda last_modified |
| qualified_arn | AWS lambda qualified_arn |
| source_code_hash | AWS lambda source_code_hash |
| source_code_size | AWS lambda source_code_size |
| version | AWS lambda version |

