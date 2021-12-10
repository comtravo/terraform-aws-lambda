## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_function_arn"></a> [lambda\_function\_arn](#input\_lambda\_function\_arn) | Lambda arn | `string` | n/a | yes |
| <a name="input_sqs_external"></a> [sqs\_external](#input\_sqs\_external) | External SQS to consume | <pre>object({<br>    batch_size = number<br>    sqs_arns   = list(string)<br>  })</pre> | `null` | no |

## Outputs

No outputs.
