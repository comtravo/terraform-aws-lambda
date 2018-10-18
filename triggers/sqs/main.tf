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
  sns_topics = "${compact(split(",", chomp(lookup(var.sqs_config, "sns_topic_arn", ""))))}"
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
  "maxReceiveCount": "${lookup(var.sqs_config, "max_receive_count")}"
}
EOF

  tags = "${var.tags}"
}

resource "aws_sqs_queue_policy" "SendMessage" {
  count     = "${var.enable * length(local.sns_topics)}"
  queue_url = "${element(aws_sqs_queue.sqs.*.id, 0)}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "SQS:SendMessage",
            "Resource": "${element(aws_sqs_queue.sqs.*.arn, 0)}",
            "Condition": {
                "ArnEquals": {
                "aws:SourceArn": "${trimspace(element(local.sns_topics, count.index))}"
            }
          }
        }
      ]
}
POLICY
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