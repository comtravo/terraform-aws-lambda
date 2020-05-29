
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = "~> 2.0"
  }
  experiments = [variable_validation]
}
