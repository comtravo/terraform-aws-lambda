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

resource "random_pet" "bucket_name" {
}

resource "aws_s3_bucket" "b" {
  bucket = "ct-${random_pet.bucket_name.id}"
  acl    = "private"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "foo/bar/baz/foo.zip"
  source = "${path.module}/../../test/fixtures/foo.zip"
  etag   = filemd5("${path.module}/../../test/fixtures/foo.zip")
}


module "s3" {

  source = "../../"

  s3_bucket         = aws_s3_bucket.b.id
  s3_key            = aws_s3_bucket_object.object.key
  s3_object_version = aws_s3_bucket_object.object.version_id
  function_name     = var.function_name
  handler           = "index.handler"
  role              = aws_iam_role.lambda.arn
  trigger = {
    type = "api-gateway"
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
  value       = module.s3.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = module.s3.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = module.s3.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = module.s3.version
}

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.s3.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.s3.queue
}

