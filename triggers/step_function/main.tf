/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by Step functions
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
  description = "Lambda function arn"
}

resource "aws_lambda_permission" "allow_invocation_from_sfn" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromSfn"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "states.${var.region}.amazonaws.com"
}

