/**
* # Trigger plugin for the AWS Lambda module
*
* ## Introduction
* Allow this lambda to be triggered by SQS and optionally subscribe to SNS topics
*/

variable "enable" {
  default     = false
  type        = bool
  description = "Enable module"
}

locals {
  enable_count = var.enable ? 1 : 0
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda function arn"
}

variable "sqs_config" {
  type = object({
    sns_topics : string
    fifo : bool
    sqs_name : string
    visibility_timeout_seconds : number
    batch_size : number
  })
  description = "SQS config"
}

locals {
  sns_topics = "${compact(split(",", chomp(replace(lookup(var.sqs_config, "sns_topics", ""), "\n", ""))))}"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

locals {
  sqs_name     = var.sqs_config.fifo ? "${var.sqs_config.sqs_name}.fifo" : var.sqs_config.sqs_name
  sqs_dlq_name = var.sqs_config.fifo ? "${var.sqs_config.sqs_name}-dlq.fifo" : "${var.sqs_config.sqs_name}-dlq"
}

resource "aws_sqs_queue" "sqs-deadletter" {
  count      = local.enable_count
  name       = local.sqs_dlq_name
  fifo_queue = var.sqs_config.fifo

  tags = var.tags
}

resource "aws_sqs_queue" "sqs" {
  count                      = local.enable_count
  name                       = local.sqs_name
  visibility_timeout_seconds = var.sqs_config.visibility_timeout_seconds
  fifo_queue                 = var.sqs_config.fifo

  redrive_policy = <<EOF
{
  "deadLetterTargetArn": "${element(aws_sqs_queue.sqs-deadletter.*.arn, 0)}",
  "maxReceiveCount": 12
}
EOF

  tags = var.tags
}

locals {
  setup_sns_subscription_iam_policy = var.enable && length(local.sns_topics) != 0 ? 1 : 0
  sns_topic_subscriptions_count     = local.enable_count * length(local.sns_topics)
}

data "aws_iam_policy_document" "SendMessage" {
  count = local.setup_sns_subscription_iam_policy

  statement {
    effect  = "Allow"
    actions = ["SQS:SendMessage"]
    resources = [
      element(aws_sqs_queue.sqs.*.arn, 0)
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:ArnLike"
      variable = "aws:SourceArn"
      values   = local.sns_topics
    }
  }
}

resource "aws_sqs_queue_policy" "SendMessage" {
  count     = local.setup_sns_subscription_iam_policy
  queue_url = element(aws_sqs_queue.sqs.*.id, 0)

  policy = data.aws_iam_policy_document.SendMessage[0].json
}

resource "aws_sns_topic_subscription" "to-sqs" {
  count     = local.sns_topic_subscriptions_count
  protocol  = "sqs"
  topic_arn = trimspace(element(local.sns_topics, count.index))
  endpoint  = element(aws_sqs_queue.sqs.*.arn, 0)
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  count            = local.enable_count
  batch_size       = var.sqs_config.batch_size
  event_source_arn = element(aws_sqs_queue.sqs.*.arn, 0)
  enabled          = true
  function_name    = var.lambda_function_arn
}

output "dlq" {
  description = "Dead letter queue details"
  value = {
    id  = var.enable ? aws_sqs_queue.sqs-deadletter[0].id : ""
    url = var.enable ? aws_sqs_queue.sqs-deadletter[0].id : ""
    arn = var.enable ? aws_sqs_queue.sqs-deadletter[0].arn : ""
  }
}

output "queue" {
  description = "SQS queue details"
  value = {
    id  = var.enable ? aws_sqs_queue.sqs[0].id : ""
    url = var.enable ? aws_sqs_queue.sqs[0].id : ""
    arn = var.enable ? aws_sqs_queue.sqs[0].arn : ""
  }
}
