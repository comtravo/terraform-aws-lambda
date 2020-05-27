# Terraform AWS module for AWS Lambda

## Introduction  
Allow this lambda to be triggered by Cloudwatch Event Trigger

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
| event\_config | Cloudwatch event configuration | <pre>object({<br>    name : string<br>    description : string<br>    event_pattern : string<br>  })</pre> | n/a | yes |
| lambda\_function\_arn | Lambda function arn | `string` | n/a | yes |
| enable | Enable module | `bool` | `false` | no |

## Outputs

No output.

