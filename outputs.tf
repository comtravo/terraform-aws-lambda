output arn {
  description = "AWS lambda arn"
  value       = "${aws_lambda_function.lambda.arn}"
}

output qualified_arn {
  description = "AWS lambda qualified_arn"
  value       = "${aws_lambda_function.lambda.qualified_arn}"
}

output invoke_arn {
  description = "AWS lambda invoke_arn"
  value       = "${aws_lambda_function.lambda.invoke_arn}"
}

output version {
  description = "AWS lambda version"
  value       = "${aws_lambda_function.lambda.version}"
}

output last_modified {
  description = "AWS lambda last_modified"
  value       = "${aws_lambda_function.lambda.last_modified}"
}

output source_code_hash {
  description = "AWS lambda source_code_hash"
  value       = "${aws_lambda_function.lambda.source_code_hash}"
}

output source_code_size {
  description = "AWS lambda source_code_size"
  value       = "${aws_lambda_function.lambda.source_code_size}"
}

output "dlq-url" {
  description = "AWS lambda DLQ URL"
  value       = "${element(compact(concat(module.triggered-by-sqs.dlq-id, module.triggered-by-sqs-fifo.dlq-id)), 0)}"
}

output "dlq-arn" {
  description = "AWS lambda DLQ ARN"
  value       = "${element(compact(concat(module.triggered-by-sqs.dlq-arn, module.triggered-by-sqs-fifo.dlq-arn)), 0)}"
}

output "queue-url" {
  description = "AWS lambda SQS URL"
  value       = "${element(compact(concat(module.triggered-by-sqs.id, module.triggered-by-sqs-fifo.id)), 0)}"
}

output "queue-arn" {
  description = "AWS lambda SQS ARN"
  value       = "${element(compact(concat(module.triggered-by-sqs.arn, module.triggered-by-sqs-fifo.arn)), 0)}"
}
