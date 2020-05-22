variable "enable" {
  default     = 0
  description = "0 to disable and 1 to enable this module"
}

variable "region" {
  description = "AWS region"
}

variable "lambda_function_arn" {
  description = "ARN of the lambda"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "logs.${var.region}.amazonaws.com"
}
