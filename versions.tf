
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = "~> 3.0"
  }
  experiments = [variable_validation]
}
