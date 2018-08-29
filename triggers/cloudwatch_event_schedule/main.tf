variable "enable" {
  default = 0
}

variable "schedule_config" {
  default = {}
  type    = "map"
}

variable "lambda_function_arn" {}

resource "aws_cloudwatch_event_rule" "rule" {
  count               = "${var.enable}"
  name                = "${lookup(var.schedule_config, "name")}"
  description         = "${lookup(var.schedule_config, "description")}"
  schedule_expression = "${lookup(var.schedule_config, "schedule_expression")}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = "${var.enable}"
  rule  = "${element(aws_cloudwatch_event_rule.rule.*.name, count.index)}"
  arn   = "${var.lambda_function_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${element(aws_cloudwatch_event_rule.rule.*.arn, count.index)}"
}
