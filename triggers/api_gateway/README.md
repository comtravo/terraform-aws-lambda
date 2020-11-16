# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by API Gateways

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
| lambda_function_arn | Lambda arn | `string` | n/a | yes |
| enable | Enable API Gateway trigger | `bool` | `false` | no |

## Outputs

No output.

