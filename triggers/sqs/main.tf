variable "enable" {
  default = 0
}

variable "lambda_function_arn" {}

variable "sqs_config" {
  type = "map"
}

variable "tags" {
  type = "map"
}

locals {
  sns_topics = "${compact(split(",", chomp(replace(lookup(var.sqs_config, "sns_topic_arn", ""), "\n", ""))))}"
}

resource "aws_sqs_queue" "sqs-deadletter" {
  count = "${var.enable}"
  name  = "${lookup(var.sqs_config, "sqs_name")}-dlq"

  tags = "${var.tags}"
}

resource "aws_sqs_queue" "sqs" {
  count                      = "${var.enable}"
  name                       = "${lookup(var.sqs_config, "sqs_name")}"
  visibility_timeout_seconds = "${lookup(var.sqs_config, "visibility_timeout_seconds")}"

  redrive_policy = <<EOF
{
  "deadLetterTargetArn": "${element(aws_sqs_queue.sqs-deadletter.*.arn, 0)}",
  "maxReceiveCount": 12
}
EOF

  tags = "${var.tags}"
}

data "aws_iam_policy_document" "SendMessage" {
  count = "${var.enable}"

  statement {
    effect    = "Allow"
    actions   = "${list("SQS:SendMessage")}"
    resources = ["${element(aws_sqs_queue.sqs.*.arn, 0)}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:ArnLike"
      variable = "aws:SourceArn"
      values   = ["${local.sns_topics}"]
    }
  }
}

resource "aws_sqs_queue_policy" "SendMessage" {
  count     = "${var.enable * length(local.sns_topics) >= 1 ? 1: 0}"
  queue_url = "${element(aws_sqs_queue.sqs.*.id, 0)}"

  policy = "${data.aws_iam_policy_document.SendMessage.json}"
}

resource aws_sns_topic_subscription "to-sqs" {
  count     = "${var.enable * length(local.sns_topics)}"
  protocol  = "sqs"
  topic_arn = "${trimspace(element(local.sns_topics, count.index))}"
  endpoint  = "${element(aws_sqs_queue.sqs.*.arn, 0)}"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  count            = "${var.enable}"
  batch_size       = "${lookup(var.sqs_config, "batch_size")}"
  event_source_arn = "${element(aws_sqs_queue.sqs.*.arn, 0)}"
  enabled          = true
  function_name    = "${var.lambda_function_arn}"
}

output "dlq-id" {
  description = "DLQ endpoint"
  value       = "${aws_sqs_queue.sqs-deadletter.id}"
}

output "dlq-arn" {
  description = "DLQ ARN"
  value       = "${aws_sqs_queue.sqs-deadletter.arn}"
}
