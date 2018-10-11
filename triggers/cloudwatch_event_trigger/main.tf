variable "enable" {
  default = 0
}

variable "event_config" {
  default = {}
  type    = "map"
}

variable "lambda_function_arn" {}

resource "aws_cloudwatch_event_rule" "event_rule" {
  count       = "${var.enable}"
  name        = "${lookup(var.event_config, "name")}"
  description = "${lookup(var.event_config, "description")}"

  event_pattern = "${lookup(var.event_config, "event_pattern")}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = "${var.enable}"
  rule  = "${aws_cloudwatch_event_rule.event_rule.name}"
  arn   = "${var.lambda_function_arn}"
}

resource "aws_lambda_permission" "invoke-from-events" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.event_rule.arn}"
}
