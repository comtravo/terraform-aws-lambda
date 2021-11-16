## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| lambda\_function\_arn | Lambda arn | `string` | n/a | yes |
| sqs\_external | External SQS to consume | <pre>object({<br>    batch_size = number<br>    sqs_arns   = list(string)<br>  })</pre> | `null` | no |

## Outputs

No output.
