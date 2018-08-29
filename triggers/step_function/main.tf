variable "enable" {
  default = 0
}

variable "region" {}

variable "lambda_function_arn" {}

resource "aws_lambda_permission" "allow_invocation_from_sfn" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromSfn"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "states.${var.region}.amazonaws.com"
}
