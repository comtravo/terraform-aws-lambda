variable "enable" {
  default     = 0
  description = "0 to disable and 1 to enable this module"
}

variable "lambda_function_arn" {
  description = "ARN of the lambda"
}

resource "aws_lambda_permission" "allow_invocation_from_cognito_idp" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "cognito-idp.amazonaws.com"
}
