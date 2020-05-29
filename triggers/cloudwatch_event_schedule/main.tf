/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by Cloudwatch Event Schedule
*/

variable "enable" {
  default     = false
  type        = bool
  description = "Enable module"
}

locals {
  enable_count = var.enable ? 1 : 0
}

variable "schedule_config" {
  type = object({
    name : string
    description : string
    schedule_expression : string
  })
  description = "CloudWatch event schedule configuration"
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda function arn"
}

resource "aws_cloudwatch_event_rule" "rule" {
  count               = local.enable_count
  name                = var.schedule_config.name
  description         = var.schedule_config.description
  schedule_expression = var.schedule_config.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = local.enable_count
  rule  = element(aws_cloudwatch_event_rule.rule.*.name, count.index)
  arn   = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = local.enable_count
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = element(aws_cloudwatch_event_rule.rule.*.arn, count.index)
}

