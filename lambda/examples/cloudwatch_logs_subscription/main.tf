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


module "cloudwatch_log_consumer" {

  source = "../../"

  file_name     = "${path.module}/../../test/fixtures/foo.zip"
  function_name = "${var.function_name}-consumer"
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn
  trigger = {
    type = "cloudwatch-logs"
  }
  environment = {
    Foo = "bar"
  }
  region = "us-east-1"
}

module "cloudwatch_log_producer" {

  source = "../../"

  file_name     = "${path.module}/../../test/fixtures/foo.zip"
  function_name = "${var.function_name}-producer"
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn
  trigger = {
    type = "api-gateway"
  }
  environment = {
    Foo = "bar"
  }
  cloudwatch_log_subscription = {
    enable          = true
    destination_arn = module.cloudwatch_log_consumer.arn
    filter_pattern  = "[timestamp=*Z, request_id=\"*-*\", logLevel=*, event]"
  }
  region = "us-east-1"
}

output "arn" {
  description = "AWS lambda arn"
  value       = module.cloudwatch_log_consumer.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = module.cloudwatch_log_consumer.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = module.cloudwatch_log_consumer.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = module.cloudwatch_log_consumer.version
}

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.cloudwatch_log_consumer.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.cloudwatch_log_consumer.queue
}

