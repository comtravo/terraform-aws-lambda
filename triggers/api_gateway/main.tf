variable "enable" {
  default = 0
}

variable "lambda_function_arn" {}

resource "aws_lambda_permission" "allow_apigateway" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "apigateway.amazonaws.com"
}
