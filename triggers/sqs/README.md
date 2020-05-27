## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| lambda\_function\_arn | Lambda function arn | `string` | n/a | yes |
| sqs\_config | SQS config | <pre>object({<br>    sns_topics : list(string)<br>    sqs_name : string<br>    visibility_timeout_seconds : number<br>    batch_size : number<br>  })</pre> | n/a | yes |
| tags | Tags | `map(string)` | n/a | yes |
| enable | Enable module | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| dlq-arn | Dead letter queue arn |
| dlq-id | Dead letter queue endpoint |
