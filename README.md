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
| file\_name | Lambda function filename name | `string` | n/a | yes |
| function\_name | Lambda function name | `string` | n/a | yes |
| handler | Lambda function handler | `string` | n/a | yes |
| region | AWS region | `string` | n/a | yes |
| role | Lambda function role | `string` | n/a | yes |
| trigger | Trigger configuration for this lambda function | `map(string)` | n/a | yes |
| vpc\_config | Lambda VPC configuration | <pre>object({<br>    subnet_ids : list(string)<br>    security_group_ids : list(string)<br>  })</pre> | n/a | yes |
| cloudwatch\_log\_retention | Enable Cloudwatch logs retention | `number` | `90` | no |
| cloudwatch\_log\_subscription | Cloudwatch log stream configuration | <pre>object({<br>    enable : bool<br>    filter_pattern : string<br>    destination_arn : string<br>  })</pre> | <pre>{<br>  "destination_arn": null,<br>  "enable": false,<br>  "filter_pattern": null<br>}</pre> | no |
| description | Lambda function description | `string` | `"Managed by Terraform"` | no |
| environment | Lambda environment variables | `map(string)` | `{}` | no |
| layers | List of layers for this lambda function | `list(string)` | `[]` | no |
| memory\_size | Lambda function memory size | `number` | `128` | no |
| publish | Publish lambda function | `bool` | `false` | no |
| reserved\_concurrent\_executions | Reserved concurrent executions  for this lambda function | `number` | `-1` | no |
| runtime | Lambda function runtime | `string` | `"nodejs12.x"` | no |
| tags | Tags for this lambda function | `map` | `{}` | no |
| timeout | Lambda function runtime | `number` | `300` | no |
| tracing\_config | https://www.terraform.io/docs/providers/aws/r/lambda_function.html | <pre>object({<br>    mode : string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS lambda arn |
| dlq | AWS lambda DLQ details |
| invoke\_arn | AWS lambda invoke\_arn |
| last\_modified | AWS lambda last\_modified |
| qualified\_arn | AWS lambda qualified\_arn |
| queue | AWS lambda SQS details |
| source\_code\_hash | AWS lambda source\_code\_hash |
| source\_code\_size | AWS lambda source\_code\_size |
| version | AWS lambda version |

