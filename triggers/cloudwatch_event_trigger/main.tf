/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by Cloudwatch Event Trigger
*/

variable "enable" {
  default     = false
  type        = bool
  description = "Enable module"
}

locals {
  enable_count = var.enable ? 1 : 0
}

variable "event_config" {
  type = object({
    name : string
    description : string
    event_pattern : string
  })
  description = "Cloudwatch event configuration"
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda function arn"
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  count         = local.enable_count
  name          = var.event_config.name
  description   = var.event_config.description
  event_pattern = var.event_config.event_pattern
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = local.enable_count
  rule  = aws_cloudwatch_event_rule.event_rule[0].name
  arn   = var.lambda_function_arn
}

resource "aws_lambda_permission" "invoke-from-events" {
  count         = local.enable_count
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule[0].arn
}

