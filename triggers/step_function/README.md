# Terraform AWS module for AWS Lambda

## Introduction  
Allow this lambda to be triggered by Step functions

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
| lambda\_function\_arn | Lambda function arn | `string` | n/a | yes |
| region | AWS region | `string` | n/a | yes |
| enable | Enable module | `bool` | `false` | no |

## Outputs

No output.

