variable "lambda_function_arn" {
  type        = string
  description = "Lambda arn"
}

variable "kinesis_configuration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping"
  type = map(object({
    batch_size                                      = number
    bisect_batch_on_function_error                  = bool
    destination_config__on_failure__destination_arn = string
    event_source_arn                                = string
    maximum_batching_window_in_seconds              = number
    maximum_record_age_in_seconds                   = number
    maximum_retry_attempts                          = number
    parallelization_factor                          = number
    starting_position                               = string
    starting_position_timestamp                     = string
    tumbling_window_in_seconds                      = number
  }))
  default = {}
}


resource "aws_lambda_event_source_mapping" "this" {
  for_each = var.kinesis_configuration

  function_name = var.lambda_function_arn

  batch_size                         = each.value.batch_size
  bisect_batch_on_function_error     = each.value.bisect_batch_on_function_error
  event_source_arn                   = each.value.event_source_arn
  maximum_batching_window_in_seconds = each.value.maximum_batching_window_in_seconds
  maximum_record_age_in_seconds      = each.value.maximum_record_age_in_seconds
  maximum_retry_attempts             = each.value.maximum_retry_attempts
  parallelization_factor             = each.value.parallelization_factor
  starting_position                  = each.value.starting_position
  starting_position_timestamp        = each.value.starting_position_timestamp
  tumbling_window_in_seconds         = each.value.tumbling_window_in_seconds
  destination_config {
    on_failure {
      destination_arn = each.value.destination_config__on_failure__destination_arn
    }
  }
}
