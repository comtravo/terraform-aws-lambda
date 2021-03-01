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


module "cloudwatch_event_pattern_trigger" {

  source = "../../"

  file_name     = "${path.module}/../../test/fixtures/foo.zip"
  function_name = var.function_name
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn
  trigger = {
    type          = "cloudwatch-event-trigger"
    event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "foo-bar-baz"
      ]
    }
  }
}
PATTERN
  }
  environment = {
    "LOREM" = "IPSUM"
  }
  region = "us-east-1"
  tags = {
    "Foo" : var.function_name
  }
}

output "arn" {
  description = "AWS lambda arn"
  value       = module.cloudwatch_event_pattern_trigger.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = module.cloudwatch_event_pattern_trigger.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = module.cloudwatch_event_pattern_trigger.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = module.cloudwatch_event_pattern_trigger.version
}

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.cloudwatch_event_pattern_trigger.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.cloudwatch_event_pattern_trigger.queue
}

