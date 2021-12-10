/**
* # Terraform AWS module for AWS Lambda
*
* ## Introduction
* This module creates an AWS lambda and all the related resources. It is a complete re-write of our internal terraform lambda module.
*
* ## Usage
* Checkout [examples](./examples) on how to use this module for various trigger sources.
* ## Authors
*
* Module managed by [Comtravo](https://github.com/comtravo).
*
* ## License
*
* MIT Licensed. See LICENSE for full details.
*/


# Create the lambda function
resource "aws_lambda_function" "lambda" {
  filename                       = var.file_name
  function_name                  = var.function_name
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_object_version
  layers                         = var.layers
  handler                        = var.handler
  role                           = var.role
  description                    = var.description
  memory_size                    = var.memory_size
  runtime                        = var.runtime
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish
  source_code_hash               = local.source_code_hash
  image_uri                      = var.image_uri
  package_type                   = var.image_uri != null ? "Image" : "Zip"

  dynamic "image_config" {
    for_each = var.image_config == null ? [] : [var.image_config]

    content {
      command           = image_config.value.command
      entry_point       = image_config.value.entry_point
      working_directory = image_config.value.working_directory
    }
  }

  tracing_config {
    mode = var.tracing_config.mode
  }

  vpc_config {
    subnet_ids         = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
  }

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]

    content {
      variables = environment.value
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_retention
}

module "triggered-by-cloudwatch-event-schedule" {
  enable = var.trigger.type == "cloudwatch-event-schedule"

  source = "./triggers/cloudwatch_event_schedule/"

  lambda_function_arn = aws_lambda_function.lambda.arn

  schedule_config = {
    name                = var.function_name
    description         = var.description
    schedule_expression = lookup(var.trigger, "schedule_expression", "")
  }
}

module "triggered-by-cloudwatch-event-trigger" {
  enable = var.trigger.type == "cloudwatch-event-trigger"

  source = "./triggers/cloudwatch_event_trigger/"

  lambda_function_arn = aws_lambda_function.lambda.arn

  event_config = {
    name          = var.function_name
    description   = var.description
    event_pattern = lookup(var.trigger, "event_pattern", "")
  }
}

module "triggered-by-step-function" {
  enable = var.trigger.type == "step-function"

  source = "./triggers/step_function/"

  lambda_function_arn = aws_lambda_function.lambda.arn
  region              = var.region
}

module "triggered-by-api-gateway" {
  enable = var.trigger.type == "api-gateway"

  source = "./triggers/api_gateway/"

  lambda_function_arn = aws_lambda_function.lambda.arn
}

module "triggered-by-cognito-idp" {
  enable = var.trigger.type == "cognito-idp"

  source = "./triggers/cognito_idp/"

  lambda_function_arn = aws_lambda_function.lambda.arn
}

module "triggered-by-cloudwatch-logs" {
  enable = var.trigger.type == "cloudwatch-logs"

  source = "./triggers/cloudwatch_logs/"

  lambda_function_arn = aws_lambda_function.lambda.arn
  region              = var.region
}

module "triggered-by-sqs" {
  enable = var.trigger.type == "sqs"

  source = "./triggers/sqs/"

  lambda_function_arn = aws_lambda_function.lambda.arn

  sqs_config = {
    sns_topics                 = try(var.trigger.sns_topics, [])
    sqs_name                   = var.function_name
    visibility_timeout_seconds = var.timeout + 5
    batch_size                 = tonumber(try(var.trigger.batch_size, "1"))
    fifo                       = tobool(try(var.trigger.fifo, false))
  }

  tags = local.tags
}

module "triggered_by_kinesis" {
  source = "./triggers/kinesis/"

  lambda_function_arn   = aws_lambda_function.lambda.arn
  kinesis_configuration = var.kinesis_configuration
}

module "sqs_external" {
  source = "./triggers/sqs_external/"

  lambda_function_arn = aws_lambda_function.lambda.arn
  sqs_external        = var.sqs_external
}

module "cloudwatch-log-subscription" {
  enable = var.cloudwatch_log_subscription.enable

  source = "./log_subscription/"

  lambda_name                 = aws_lambda_function.lambda.function_name
  log_group_name              = aws_cloudwatch_log_group.lambda.name
  cloudwatch_log_subscription = var.cloudwatch_log_subscription
}

