## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| lambda\_function\_arn | Lambda arn | string | n/a | yes |
| sqs\_config | SQS queue configuration | map | n/a | yes |
| tags | Tags | map | n/a | yes |
| enable | 0 to disable and 1 to enable this module | string | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| dlq\_arn | DLQ ARN |
| dlq\_id | DLQ ID |
| queue\_arn | SQS ARN |
| queue\_id | SQS endpoint |

