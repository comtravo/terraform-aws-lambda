/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by API Gateways
*/

variable "enable" {
  default     = false
  type        = bool
  description = "Enable API Gateway trigger"
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda arn"
}

resource "aws_lambda_permission" "allow_apigateway" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "apigateway.amazonaws.com"
}

