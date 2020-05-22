# Terraform AWS Lambda module with various triggers.

##  Usage:
For detailed examples: check the triigers folder for triggers specific examples.

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
   type = "cloudwatch-event-trigger"

   event_pattern = <<PATTERN
{
 "source": [
   "aws.s3"
 ],
 "detail-type": [
   "AWS API Call via CloudTrail"
 ],
 "detail": {
   "eventSource": [
     "s3.amazonaws.com"
   ],
   "eventName": [
     "PutObject"
   ],
   "requestParameters": {
     "bucketName": [
       "${local.ct_s3_bucket_name["data_logs"]}"
     ]
   }
 }
}
PATTERN
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
| enable | 0 to disable and 1 to enable this module | string | `"0"` | no |
| event\_config | Cloudwatch event configuration | map | `<map>` | no |

