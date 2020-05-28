

## Generic example:
```hcl
module "lambda-offer-email" {
 source = "github.com/comtravo/terraform-aws-lambda?ref=2.4.0"

 ################################################
 #        LAMBDA FUNCTION CONFIGURATION         #
 file_name = "${path.root}/../artifacts/offer-email.zip"

 function_name = "lambda-offer-email-${terraform.workspace}"
 handler       = "index.offerEmails"
 memory_size   = 1024

 trigger {
   type          = "sqs-fifo"
   sns_topic_arn = "arn:aws:sns:${var.region}:${var.ct_account_id}:lambda-offer-${terraform.workspace}"
 }

 environment = "${merge(
   local.ct_lambda_commons,
   map(
     "FOO", "baz",
     "LOREM", "ipsum",
   )
 )}"

 enable_cloudwatch_log_subscription = true

 cloudwatch_log_subscription {
   destination_arn = "${module.lambda-elk-logging.lambda_arn}"
   filter_pattern  = "[timestamp=*Z, request_id=\"*-*\", logLevel=*, event]"
 }

 tracing_config = "${var.lambda_xray_config}"

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| lambda\_function\_arn | Lambda arn | string | n/a | yes |
| sqs\_config | SQS queue configuration | map | n/a | yes |
| tags | Tags | map | n/a | yes |
| enable | 0 to disable and 1 to enable this module | string | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| dlq\_arn | Dead Letter Queue arn |
| dlq\_id | Dead Leter Queue endpoint |
| queue\_arn | SQS arn |
| queue\_id | SQS endpoint |
