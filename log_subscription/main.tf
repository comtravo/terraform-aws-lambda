variable "enable" {
  default     = 0
  description = "0 to disable and 1 to enable this module"
}

variable "lambda_name" {
  description = "ARN of the lambda"
}

variable "log_group_name" {
  description = "Lambda cloud watch logs stream name"
}

variable "cloudwatch_log_subscription" {
  type        = "map"
  description = "Cloudwatch log subscription configuration"
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_cloudwatch_subscription" {
  count           = "${var.enable}"
  name            = "${var.lambda_name}"
  log_group_name  = "${var.log_group_name}"
  filter_pattern  = "${lookup(var.cloudwatch_log_subscription, "filter_pattern", "")}"
  destination_arn = "${lookup(var.cloudwatch_log_subscription, "destination_arn", "")}"
}
