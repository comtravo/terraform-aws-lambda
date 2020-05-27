# Trigger plugin for the AWS Lambda module

## Introduction  
Allow this lambda to be triggered by API Gateways

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
| lambda\_function\_arn | Lambda arn | `string` | n/a | yes |
| enable | Enable API Gateway trigger | `bool` | `false` | no |

## Outputs

No output.

