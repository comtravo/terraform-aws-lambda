variable "file_name" {
  description = "Lambda function filename name"
  type        = string
  default     = null
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package"
  type        = string
  default     = null
}

variable "image_config" {
  description = "Container image configuration values that override the values in the container image Dockerfile."
  type = object({
    command           = list(string)
    entry_point       = list(string)
    working_directory = string
  })
  default = null
}

variable "s3_bucket" {
  description = "S3 bucket name where lambda package is stored"
  default     = null
  type        = string
}

variable "s3_key" {
  description = "S3 key where lambda package is stored"
  default     = null
  type        = string
}

variable "s3_object_version" {
  description = "S3 object version of the lambda package"
  default     = null
  type        = string
}

variable "layers" {
  description = "List of layers for this lambda function"
  type        = list(string)
  default     = []
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = null
}

variable "role" {
  description = "Lambda function role"
  type        = string
}

variable "description" {
  description = "Lambda function description"
  default     = "Managed by Terraform"
  type        = string
}

variable "memory_size" {
  description = "Lambda function memory size"
  default     = 128
  type        = number
}

variable "runtime" {
  description = "Lambda function runtime"
  default     = "nodejs14.x"
  type        = string
}



variable "timeout" {
  description = "Lambda function runtime"
  default     = 300
  type        = number
}

variable "publish" {
  description = "Publish lambda function"
  default     = false
  type        = bool
}

variable "vpc_config" {
  description = "Lambda VPC configuration"
  type = object({
    subnet_ids : list(string)
    security_group_ids : list(string)
  })
  default = {
    subnet_ids : []
    security_group_ids : []
  }
}

variable "environment" {
  description = "Lambda environment variables"
  type        = map(string)
  default     = null
}

variable "trigger" {
  description = "Trigger configuration for this lambda function"
  type        = any

  validation {
    condition = contains([
      "api-gateway",
      "cloudwatch-logs",
      "cognito-idp",
      "cloudwatch-event-schedule",
      "cloudwatch-event-trigger",
      "sqs",
      "sqs-external",
      "step-function",
      "kinesis",
      "null",
    ], var.trigger.type)

    error_message = "Unknown trigger type."
  }
}

variable "cloudwatch_log_subscription" {
  description = "Cloudwatch log stream configuration"
  type = object({
    enable : bool
    filter_pattern : string
    destination_arn : string
  })
  default = {
    enable : false
    filter_pattern : ""
    destination_arn : ""
  }
}

variable "tags" {
  description = "Tags for this lambda function"
  default     = {}
  type        = map(string)
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions  for this lambda function"
  default     = -1
  type        = number
}

variable "region" {
  description = "AWS region"
  type        = string
}


variable "cloudwatch_log_retention" {
  description = "Enable Cloudwatch logs retention"
  default     = 90
  type        = number
}

locals {
  _tags = {
    Name        = var.function_name
    environment = terraform.workspace
  }
}

locals {
  source_code_hash          = var.file_name != null ? filebase64sha256(var.file_name) : null
  tags                      = merge(var.tags, local._tags)
  cloudwatch_log_group_name = "/aws/lambda/${var.function_name}"
}

variable "tracing_config" {
  type = object({
    mode : string
  })
  default = {
    mode = "PassThrough"
  }

  description = "https://www.terraform.io/docs/providers/aws/r/lambda_function.html"
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

variable "sqs_external" {
  description = "External SQS to consume"
  type = object({
    batch_size = number
    sqs_arns   = list(string)
  })
  default = null
}
