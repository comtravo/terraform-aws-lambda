# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by Cloudwatch logs

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
| lambda\_function\_arn | Lambda arn | `string` | n/a | yes |
| region | AWS region | `string` | n/a | yes |

## Outputs

No output.
