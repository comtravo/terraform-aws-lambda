# Terraform AWS module for AWS Lambda

## Introduction
This module creates an AWS lambda and all the related resources. It is a complete re-write of our internal terraform lambda module and all functionality has not yet been tested.

## Usage
```hcl
module "lambda-foo" {
  source = "github.com/comtravo/terraform-aws-lambda"

  ################################################
  #        LAMBDA FUNCTION CONFIGURATION         #
  file_name = "${path.root}/artifacts/foo.zip"

  function_name = "lambda-foo-${terraform.workspace}"
  handler       = "index.foo"
  memory_size   = 1024

  trigger {
    type          = "sqs"
    sns_topic_arn = "some_sns_arn"
  }

  environment = "${merge(
    local.ct_lambda_commons,
    map(
      "foo", "FOO",
      "bar", "BAR",
      "baz", "BAZ",
      "jazz", "JAZZ",
      "lorem", "LOREM"
    )
  )}"

  # out of band configuration is needed because Terraform treats
  # the cloudwatch_log_subscription block as a computed resource
  # and lookup function doesn't work. Accessing via array style is not possible
  # because the cloudwatch_log_subscription block is an optional block.
  enable_cloudwatch_log_subscription = true

  cloudwatch_log_subscription {
    destination_arn = "${module.lambda-elk-logging.lambda_arn}"
    filter_pattern  = "[timestamp=*Z, request_id=\"*-*\", event]"
  }

  #                                              #
  ################################################

  region = "${var.region}"
  role   = "${aws_iam_role.lambda.arn}"
  vpc_config {
    subnet_ids         = ["${module.main_vpc.private_subnets}"]
    security_group_ids = ["${module.main_vpc.vpc_default_sg}"]
  }
}
```

## Pluggable Triggers

### Intro

This module has pluggable triggers. The triggers can be passed by the trigger block.

Example:

```hcl
  trigger {
    type          = "sqs"
    sns_topic_arn = "some_sns_arn"
  }
```
All the available triggers can be found in the [triggers folder](./triggers)



### Adding a new trigger

Triggers are regular Terraform modules but only used by the main module. The only mandatory inputs are `enable`, `lambda_function_arn` and `type`.

Below is an example of API Gateway trigger

```hcl
variable "enable" {
  default = 0
}

variable "lambda_function_arn" {}

resource "aws_lambda_permission" "allow_apigateway" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "apigateway.amazonaws.com"
}
```


## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See LICENSE for full details.
