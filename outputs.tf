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

output "function_name" {
  description = "AWS lambda function name"
  value       = aws_lambda_function.lambda.function_name
}

output "sns_topics" {
  description = "AWS lambda SNS topics if any"
  value       = try(var.trigger.sns_topics, [])
}

output "aws_lambda_function" {
  description = "AWS lambda attributes"
  value       = aws_lambda_function.lambda
}

