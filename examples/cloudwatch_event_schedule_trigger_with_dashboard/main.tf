provider "grafana" {
  url  = "http://grafana:3000"
  auth = "admin:admin"
}

variable "function_name" {
  type = string
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Do not use the below policy anywhere
data "aws_iam_policy_document" "policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "lambda" {
  name                  = var.function_name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "lambda" {
  name = var.function_name
  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.policy.json
}

resource "grafana_folder" "this" {
  title = "${var.function_name}-folder"
}

resource "grafana_data_source" "this" {
  type          = "influxdb"
  name          = "prod"
  url           = "http://influxdb.infra.comtravo.com:8086/"
  database_name = "prod"
}

resource "grafana_alert_notification" "slack_1" {
  name          = "slack_1"
  type          = "slack"
  is_default    = false
  send_reminder = true
  frequency     = "24h"

  settings = {
    recipient      = "#lorem"
    username       = "bot"
    mentionChannel = "channel"
    token          = "vdssvbdshjvbdskbvkdbv"
    iconEmoji      = ":ghost:"
    url            = "http://slack"
    uploadImage    = false
  }
}

resource "grafana_alert_notification" "slack_2" {
  name          = "slack_2"
  type          = "slack"
  is_default    = false
  send_reminder = true
  frequency     = "24h"

  settings = {
    recipient      = "#lorem"
    username       = "bot"
    mentionChannel = "channel"
    token          = "vdssvbdshjvbdskbvkdbv"
    iconEmoji      = ":ghost:"
    url            = "http://slack"
    uploadImage    = false
  }
}

module "cloudwatch_event_schedule_trigger" {

  source = "../../"

  file_name     = "${path.module}/../../test/fixtures/foo.zip"
  function_name = var.function_name
  handler       = "index.handler"
  role          = aws_iam_role.lambda.name
  trigger = {
    type                = "cloudwatch-event-schedule"
    schedule_expression = "cron(0 1 * * ? *)"
  }
  environment = {
    "LOREM" = "IPSUM"
  }
  region = "us-east-1"
  tags = {
    "Foo" : var.function_name
  }

  grafana_configuration = {
    enable        = true
    environment   = grafana_data_source.this.name
    data_source   = grafana_data_source.this.name
    notifications = [grafana_alert_notification.slack_1.id, grafana_alert_notification.slack_2.id]
    folder        = grafana_folder.this.id

  }
}

output "arn" {
  description = "AWS lambda arn"
  value       = module.cloudwatch_event_schedule_trigger.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = module.cloudwatch_event_schedule_trigger.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = module.cloudwatch_event_schedule_trigger.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = module.cloudwatch_event_schedule_trigger.version
}

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.cloudwatch_event_schedule_trigger.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.cloudwatch_event_schedule_trigger.queue
}

