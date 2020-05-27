variable "file_name" {
  description = "Lambda function filename name"
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
  default     = "nodejs12.x"
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
}

variable "environment" {
  description = "Lambda environment variables"
  type        = map(string)
  default     = {}
}

variable "trigger" {
  description = "Trigger configuration for this lambda function"
  type        = map(string)
}

variable "cloudwatch_log_subscription" {
  description = "Cloudwatch log stream configuration"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for this lambda function"
  default     = {}
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

variable "enable_cloudwatch_log_subscription" {
  description = "Enable Cloudwatch log subscription"
  default     = false
  type        = bool
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
  source_code_hash = filebase64sha256(var.file_name)

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
