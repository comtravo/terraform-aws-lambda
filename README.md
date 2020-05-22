## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| file\_name | lambda function filename name | string | n/a | yes |
| function\_name | lambda function name | string | n/a | yes |
| handler | lambda function handler | string | n/a | yes |
| region | AWS region | string | n/a | yes |
| role | lambda function role | string | n/a | yes |
| trigger | trigger configuration for this lambda function | map | n/a | yes |
| vpc\_config |  | map | n/a | yes |
| cloudwatch\_log\_retention |  | string | `"90"` | no |
| cloudwatch\_log\_subscription | cloudwatch log stream configuration | map | `<map>` | no |
| description | lambda function description | string | `"Managed by Terraform"` | no |
| enable\_cloudwatch\_log\_subscription |  | string | `"false"` | no |
| environment | lambda environment variables | map | `<map>` | no |
| layers | List of layers for this lambda function | list | `<list>` | no |
| memory\_size | lambda function memory size | string | `"128"` | no |
| publish | Publish lambda function | string | `"false"` | no |
| reserved\_concurrent\_executions | Reserved concurrent executions  for this lambda function | string | `"-1"` | no |
| runtime | lambda function runtime | string | `"nodejs12.x"` | no |
| tags | Tags for this lambda function | map | `<map>` | no |
| timeout | lambda function runtime | string | `"300"` | no |
| tracing\_config | https://www.terraform.io/docs/providers/aws/r/lambda\_function.html | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS lambda arn |
| dlq-arn | AWS lambda DLQ ARN |
| dlq-url | AWS lambda DLQ URL |
| invoke\_arn | AWS lambda invoke\_arn |
| last\_modified | AWS lambda last\_modified |
| qualified\_arn | AWS lambda qualified\_arn |
| source\_code\_hash | AWS lambda source\_code\_hash |
| source\_code\_size | AWS lambda source\_code\_size |
| version | AWS lambda version |

