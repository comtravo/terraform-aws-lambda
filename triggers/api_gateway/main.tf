variable "enable" {
  default     = 0
  description = "0 to disable and 1 to enable this module"
}

variable "lambda_function_arn" {
  description = "Lambda arn"
}

resource "aws_lambda_permission" "allow_apigateway" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "apigateway.amazonaws.com"
}
