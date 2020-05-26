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

output "dlq_url" {
  description = "AWS lambda DLQ url"
  value       = "${element(compact(concat(module.triggered-by-sqs.dlq_id, module.triggered-by-sqs-fifo.dlq_id)), 0)}"
}

output "dlq_arn" {
  description = "AWS lambda DLQ arn"
  value       = "${element(compact(concat(module.triggered-by-sqs.dlq_arn, module.triggered-by-sqs-fifo.dlq_arn)), 0)}"
}

output "queue_url" {
  description = "AWS lambda SQS url"
  value       = "${element(compact(concat(module.triggered-by-sqs.queue_id, module.triggered-by-sqs-fifo.queue_id)), 0)}"
}

output "queue_arn" {
  description = "AWS lambda SQS arn"
  value       = "${element(compact(concat(module.triggered-by-sqs.queue_arn, module.triggered-by-sqs-fifo.queue_arn)), 0)}"
}
