output "arn" {
  description = "AWS lambda arn"
  value       = aws_lambda_function.lambda.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = aws_lambda_function.lambda.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = aws_lambda_function.lambda.version
}

output "last_modified" {
  description = "AWS lambda last_modified"
  value       = aws_lambda_function.lambda.last_modified
}

output "source_code_hash" {
  description = "AWS lambda source_code_hash"
  value       = aws_lambda_function.lambda.source_code_hash
}

output "source_code_size" {
  description = "AWS lambda source_code_size"
  value       = aws_lambda_function.lambda.source_code_size
}

output "dlq" {
  description = "AWS lambda DLQ details"
  value       = module.triggered-by-sqs.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.triggered-by-sqs.queue
}

