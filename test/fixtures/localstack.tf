provider "aws" {
  region                      = "us-east-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  access_key                  = "This is not an actual access key."
  secret_key                  = "This is not an actual secret key."

  endpoints {
    cloudwatchevents = "http://localstack:4566"
    cloudwatchlogs   = "http://localstack:4566"
    iam              = "http://localstack:4566"
    lambda           = "http://localstack:4566"
    sns              = "http://localstack:4566"
    sqs              = "http://localstack:4566"
    sts              = "http://localstack:4566"
  }
}
