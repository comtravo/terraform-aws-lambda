variable "lambda_function_arn" {
  type        = string
  description = "Lambda arn"
}

variable "sqs_external" {
  description = "External SQS to consume"
  type = object({
    batch_size = number
    sqs_arns   = list(string)
  })
  default = null
}

resource "aws_lambda_event_source_mapping" "this" {
  for_each = var.sqs_external == null ? toset([]) : toset(var.sqs_external.sqs_arns)

  function_name    = var.lambda_function_arn
  batch_size       = var.sqs_external.batch_size
  event_source_arn = each.value
}
