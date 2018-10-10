variable "enable" {
  default = 0
}

variable "event_config" {
  default = {}
  type    = "map"
}

variable "lambda_function_arn" {}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "${lookup(event_config, "name")}"
  description = "${lookup(event_config, "description")}"

  event_pattern = "${lookup(event_config, "event_pattern")}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = "${aws_cloudwatch_event_rule.event_rule.name}"
  arn  = "${var.lambda_function_arn}"
}

resource "aws_lambda_permission" "invoke-from-events" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.event_rule.arn}"
}
