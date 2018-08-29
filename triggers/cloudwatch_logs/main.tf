variable "enable" {
  default = 0
}

variable "region" {}

variable "lambda_function_arn" {}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "logs.${var.region}.amazonaws.com"
}
