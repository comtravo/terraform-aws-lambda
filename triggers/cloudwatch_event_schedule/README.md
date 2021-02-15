# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by Cloudwatch Event Schedule

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| lambda_function_arn | Lambda function arn | `string` | n/a | yes |
| schedule_config | CloudWatch event schedule configuration | <pre>object({<br>    name : string<br>    description : string<br>    schedule_expression : string<br>  })</pre> | n/a | yes |
| enable | Enable module | `bool` | `false` | no |

## Outputs

No output.

