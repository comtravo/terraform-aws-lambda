variable "enable" {
  default = 0
}

variable "lambda_name" {}

variable "log_group_name" {}

variable "cloudwatch_log_subscription" {
  type = "map"
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_cloudwatch_subscription" {
  count           = "${var.enable}"
  name            = "${var.lambda_name}"
  log_group_name  = "${var.log_group_name}"
  filter_pattern  = "${lookup(var.cloudwatch_log_subscription, "filter_pattern", "")}"
  destination_arn = "${lookup(var.cloudwatch_log_subscription, "destination_arn", "")}"
}
