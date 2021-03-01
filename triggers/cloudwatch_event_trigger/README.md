# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by Cloudwatch Event Trigger

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
| event\_config | Cloudwatch event configuration | <pre>object({<br>    name : string<br>    description : string<br>    event_pattern : string<br>  })</pre> | n/a | yes |
| lambda\_function\_arn | Lambda function arn | `string` | n/a | yes |

## Outputs

No output.
