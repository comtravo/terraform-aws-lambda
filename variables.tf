variable "file_name" {
  description = "lambda function filename name"
}

variable "layers" {
  description = "List of layers for this lambda function"
  type        = "list"
  default     = []
}

variable "function_name" {
  description = "lambda function name"
}

variable "handler" {
  description = "lambda function handler"
}

variable "role" {
  description = "lambda function role"
}

variable "description" {
  description = "lambda function description"
  default     = "Managed by Terraform"
}

variable "memory_size" {
  description = "lambda function memory size"
  default     = 128
}

variable "runtime" {
  description = "lambda function runtime"
  default     = "nodejs8.10"
}

variable "timeout" {
  description = "lambda function runtime"
  default     = 300
}

variable "publish" {
  description = "Publish lambda function"
  default     = false
}

variable "vpc_config" {
  type = "map"
}

variable "environment" {
  description = "lambda environment variables"
  type        = "map"
  default     = {}
}

variable "trigger" {
  description = "trigger configuration for this lambda function"
  type        = "map"
}

variable "cloudwatch_log_subscription" {
  description = "cloudwatch log stream configuration"
  type        = "map"
  default     = {}
}

variable "tags" {
  description = "Tags for this lambda function"
  default     = {}
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions  for this lambda function"
  default     = -1
}

variable "region" {
  description = "AWS region"
}

variable "enable_cloudwatch_log_subscription" {
  default = false
}

variable "cloudwatch_log_retention" {
  default = 90
}

locals {
  _tags = {
    Name        = "${var.function_name}"
    environment = "${terraform.workspace}"
  }
}

locals {
  source_code_hash = "${base64sha256(file(var.file_name))}"

  tags                 = "${merge(var.tags, local._tags)}"
  cloudwatch_log_group = "/aws/lambda/${var.function_name}"
}
