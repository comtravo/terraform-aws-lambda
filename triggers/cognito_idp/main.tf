/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by Cognito IDP
*/

variable "enable" {
  default     = false
  type        = bool
  description = "Enable module"
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda function arn"
}

resource "aws_lambda_permission" "allow_invocation_from_cognito_idp" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "cognito-idp.amazonaws.com"
}

