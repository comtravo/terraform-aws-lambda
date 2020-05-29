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

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.triggered-by-sqs.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.triggered-by-sqs.queue
}

