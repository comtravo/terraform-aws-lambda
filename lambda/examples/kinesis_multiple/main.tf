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


resource "aws_kinesis_stream" "this" {
  name        = "${var.function_name}-this"
  shard_count = 1
}

resource "aws_kinesis_stream" "that" {
  name        = "${var.function_name}-that"
  shard_count = 1
}

resource "aws_sqs_queue" "this" {
  name = var.function_name
}

module "this" {

  source = "../../"

  file_name     = "${path.module}/../../test/fixtures/foo.zip"
  function_name = var.function_name
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn
  trigger = {
    type = "kinesis"
  }
  environment = {
    "LOREM" = "IPSUM"
  }
  region = "us-east-1"
  tags = {
    "Foo" : var.function_name
  }
  kinesis_configuration = {
    "test" = {
      batch_size                                      = null
      bisect_batch_on_function_error                  = null
      destination_config__on_failure__destination_arn = aws_sqs_queue.this.arn
      event_source_arn                                = aws_kinesis_stream.this.arn
      maximum_batching_window_in_seconds              = null
      maximum_record_age_in_seconds                   = null
      maximum_retry_attempts                          = null
      parallelization_factor                          = null
      starting_position                               = "LATEST"
      starting_position_timestamp                     = null
      tumbling_window_in_seconds                      = null
    }
    "that" = {
      batch_size                                      = null
      bisect_batch_on_function_error                  = null
      destination_config__on_failure__destination_arn = aws_sqs_queue.this.arn
      event_source_arn                                = aws_kinesis_stream.that.arn
      maximum_batching_window_in_seconds              = null
      maximum_record_age_in_seconds                   = null
      maximum_retry_attempts                          = null
      parallelization_factor                          = null
      starting_position                               = "LATEST"
      starting_position_timestamp                     = null
      tumbling_window_in_seconds                      = null
    }
  }
}

output "arn" {
  description = "AWS lambda arn"
  value       = module.this.arn
}
