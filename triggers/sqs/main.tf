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
  "deadLetterTargetArn": "${element(aws_sqs_queue.sqs-deadletter.*.arn, count.index)}",
  "maxReceiveCount": "${lookup(var.sqs_config, "max_receive_count")}"
}
EOF

  tags = "${var.tags}"
}

resource "aws_sqs_queue_policy" "SendMessage" {
  count     = "${var.enable}"
  queue_url = "${element(aws_sqs_queue.sqs.*.id, count.index)}"

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
            "Resource": "${element(aws_sqs_queue.sqs.*.arn, count.index)}",
            "Condition": {
                "ArnEquals": {
                "aws:SourceArn": "${lookup(var.sqs_config, "sns_topic_arn")}"
            }
          }
        }
      ]
}
POLICY
}

resource aws_sns_topic_subscription "to-sqs" {
  count     = "${var.enable}"
  protocol  = "sqs"
  topic_arn = "${lookup(var.sqs_config, "sns_topic_arn")}"
  endpoint  = "${element(aws_sqs_queue.sqs.*.arn, count.index)}"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  count            = "${var.enable}"
  batch_size       = "${lookup(var.sqs_config, "batch_size")}"
  event_source_arn = "${element(aws_sqs_queue.sqs.*.arn, count.index)}"
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
