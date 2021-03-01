# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by SQS and optionally subscribe to SNS topics

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable | Enable module | `bool` | `false` | no |
| lambda\_function\_arn | Lambda function arn | `string` | n/a | yes |
| sqs\_config | SQS config | <pre>object({<br>    sns_topics : list(string)<br>    fifo : bool<br>    sqs_name : string<br>    visibility_timeout_seconds : number<br>    batch_size : number<br>  })</pre> | n/a | yes |
| tags | Tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dlq | Dead letter queue details |
| queue | SQS queue details |
| queue\_arn | SQS ARN |
| queue\_id | SQS endpoint |
