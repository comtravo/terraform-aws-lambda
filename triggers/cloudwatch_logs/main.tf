/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by Cloudwatch logs
*/

variable "enable" {
  default     = false
  type        = bool
  description = "Enable module"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda arn"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "logs.${var.region}.amazonaws.com"
}
