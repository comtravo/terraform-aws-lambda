/**
 *
 * ##  Usage:
 *
 *
 * ## Generic example:
 *```hcl
 *module "lambda-offer-email" {
 *  source = "github.com/comtravo/terraform-aws-lambda?ref=2.4.0"
 *
 *  ################################################
 *  #        LAMBDA FUNCTION CONFIGURATION         #
 *  file_name = "${path.root}/../artifacts/offer-email.zip"
 *
 *  function_name = "lambda-offer-email-${terraform.workspace}"
 *  handler       = "index.offerEmails"
 *  memory_size   = 1024
 *
 *  trigger {
 *    type          = "step-function"
 *  }
 *
 *  environment = "${merge(
 *    local.ct_lambda_commons,
 *    map(
 *      "FOO", "baz",
 *      "LOREM", "ipsum",
 *    )
 *  )}"
 *
 *  enable_cloudwatch_log_subscription = true
 *
 *  cloudwatch_log_subscription {
 *    destination_arn = "${module.lambda-elk-logging.lambda_arn}"
 *    filter_pattern  = "[timestamp=*Z, request_id=\"*-*\", logLevel=*, event]"
 *  }
 *
 *  tracing_config = "${var.lambda_xray_config}"
 *
 *  #                                              #
 *  ################################################
 *
 *  region = "${var.region}"
 *  role   = "${aws_iam_role.lambda.arn}"
 *  vpc_config {
 *    subnet_ids         = ["${module.main_vpc.private_subnets}"]
 *    security_group_ids = ["${module.main_vpc.vpc_default_sg}"]
 *  }
 *}
 *```
 *
 */

variable "enable" {
  default     = 0
  description = "0 to disable and 1 to enable this module"
}

variable "region" {
  description = "AWS region"
}

variable "lambda_function_arn" {
  description = "Lambda arn"
}

resource "aws_lambda_permission" "allow_invocation_from_sfn" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromSfn"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "states.${var.region}.amazonaws.com"
}
