# Trigger plugin for the AWS Lambda module

## Introduction
Allow this lambda to be triggered by SQS and optionally subscribe to SNS topics

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_event_source_mapping.event_source_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_sns_topic_subscription.to-sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.sqs-deadletter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.SendMessage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_iam_policy_document.SendMessage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Enable module | `bool` | `false` | no |
| <a name="input_lambda_function_arn"></a> [lambda\_function\_arn](#input\_lambda\_function\_arn) | Lambda function arn | `string` | n/a | yes |
| <a name="input_sqs_config"></a> [sqs\_config](#input\_sqs\_config) | SQS config | <pre>object({<br>    sns_topics : list(string)<br>    fifo : bool<br>    sqs_name : string<br>    visibility_timeout_seconds : number<br>    batch_size : number<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq"></a> [dlq](#output\_dlq) | Dead letter queue details |
| <a name="output_queue"></a> [queue](#output\_queue) | SQS queue details |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | SQS ARN |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | SQS endpoint |
