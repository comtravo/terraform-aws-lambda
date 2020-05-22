/**
 *
 *
 * ## Generic example:
 *```hcl
 *module "lambda-offer-email" {
 *  source = "github.com/comtravo/terraform-aws-lambda?ref=2.4.0"
 *
 *  ################################################
 *  #        LAMBDA FUNCTION CONFIGURATION         #
 *  file_name = "${path.root}/../artifacts/offer-email.zip"
 *
 *  function_name = "lambda-offer-email-${terraform.workspace}"
 *  handler       = "index.offerEmails"
 *  memory_size   = 1024
 *
 *  trigger {
 *    type          = "sqs"
 *    sns_topic_arn = "arn:aws:sns:${var.region}:${var.ct_account_id}:lambda-offer-${terraform.workspace}"
 *  }
 *
 *  environment = "${merge(
 *    local.ct_lambda_commons,
 *    map(
 *      "FOO", "baz",
 *      "LOREM", "ipsum",
 *    )
 *  )}"
 *
 *  enable_cloudwatch_log_subscription = true
 *
 *  cloudwatch_log_subscription {
 *    destination_arn = "${module.lambda-elk-logging.lambda_arn}"
 *    filter_pattern  = "[timestamp=*Z, request_id=\"*-*\", logLevel=*, event]"
 *  }
 *
 *  tracing_config = "${var.lambda_xray_config}"
 *
 *  #                                              #
 *  ################################################
 *
 *  region = "${var.region}"
 *  role   = "${aws_iam_role.lambda.arn}"
 *  vpc_config {
 *    subnet_ids         = ["${module.main_vpc.private_subnets}"]
 *    security_group_ids = ["${module.main_vpc.vpc_default_sg}"]
 *  }
 *}
 *```
 *
 */

variable "enable" {
  default     = 0
  description = "0 to disable and 1 to enable this module"
}

variable "lambda_function_arn" {
  description = "Lambda arn"
}

variable "sqs_config" {
  type        = "map"
  description = "SQS queue configuration"
}

variable "tags" {
  type        = "map"
  description = "Tags"
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

output "dlq_id" {
  description = "DLQ ID"
  value       = "${element(concat(aws_sqs_queue.sqs-deadletter.*.id, list("")), 0)}"
}

output "dlq_arn" {
  description = "DLQ ARN"
  value       = "${element(concat(aws_sqs_queue.sqs-deadletter.*.arn, list("")), 0)}"
}

output "queue_id" {
  description = "SQS endpoint"
  value       = "${element(concat(aws_sqs_queue.sqs.*.id, list("")), 0)}"
}

output "queue_arn" {
  description = "SQS ARN"
  value       = "${element(concat(aws_sqs_queue.sqs.*.arn, list("")), 0)}"
}
