# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by Cloudwatch Event Trigger

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
| event_config | Cloudwatch event configuration | <pre>object({<br>    name : string<br>    description : string<br>    event_pattern : string<br>  })</pre> | n/a | yes |
| lambda_function_arn | Lambda function arn | `string` | n/a | yes |
| enable | Enable module | `bool` | `false` | no |

## Outputs

No output.

