variable "enable" {
  default     = false
  type        = bool
  description = "Enable this module"
}

variable "lambda_name" {
  type        = string
  description = "Lambda name"
}

variable "log_group_name" {
  type        = string
  description = "Lambda log group name"
}

variable "cloudwatch_log_subscription" {
  type = object({
    filter_pattern : string
    destination_arn : string
  })
  description = "Lambda CloudWatch log subscription"
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_cloudwatch_subscription" {
  count           = var.enable ? 1 : 0
  name            = var.lambda_name
  log_group_name  = var.log_group_name
  filter_pattern  = var.cloudwatch_log_subscription.filter_pattern
  destination_arn = var.cloudwatch_log_subscription.destination_arn
}

