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


resource "aws_sqs_queue" "fifo" {
  name       = "my-queue.fifo"
  fifo_queue = true
}

resource "aws_sqs_queue" "one" {
  name = "one"
}

resource "aws_sqs_queue" "two" {
  name = "two"
}

resource "aws_sqs_queue" "three" {
  name = "three"
}

module "sqs" {

  source = "../../"

  file_name     = "${path.module}/../../test/fixtures/foo.zip"
  function_name = var.function_name
  handler       = "index.handler"
  publish       = true
  role          = aws_iam_role.lambda.arn
  timeout       = 10

  trigger = {
    type = "sqs-external"
  }
  sqs_external = {
    batch_size = 1
    sqs_arns = [
      aws_sqs_queue.one.arn,
      aws_sqs_queue.two.arn,
      aws_sqs_queue.three.arn,
      aws_sqs_queue.fifo.arn,
    ]
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
  value       = module.sqs.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = module.sqs.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = module.sqs.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = module.sqs.version
}

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.sqs.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.sqs.queue
}

