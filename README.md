Terraform AWS Lambda module with various triggers.

Usage:
For detailed examples: check the triigers folder for triggers specific examples.

Generic example:
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
   type          = "sqs"
   sns_topic_arn = "arn:aws:sns:${var.region}:${var.ct_account_id}:lambda-offer-${terraform.workspace}"
 }

 environment = "${merge(
   local.ct_lambda_commons,
   map(
     "ZENDESK_ENDPOINT", "${var.production_env ? "https://comtravo.zendesk.com/api/v2" : "https://stagingcomtravo.zendesk.com/api/v2"}",
     "ZENDESK_USER_NAME", "infrastructure.admin@comtravo.com",
     "OFFER_SENDER_EMAIL", "${var.production_env ? "buchung@comtravo.com" : "test@comtravo.com"}",
     "OFFER_BCC_EMAIL", "${var.production_env ? "comms@comtravo.com,ms@comtravo.com" : "${join(",", var.owners)}"}",
     "SECRET_PARAM_LIST", "${jsonencode(list("S2S_JWT_SECRET_KEY", "ZENDESK_TOKEN", "LOCAL_JWT_SECRET_KEY"))}"
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
| file\_name | lambda function filename name | string | n/a | yes |
| function\_name | lambda function name | string | n/a | yes |
| handler | lambda function handler | string | n/a | yes |
| region | AWS region | string | n/a | yes |
| role | lambda function role | string | n/a | yes |
| trigger | trigger configuration for this lambda function | map | n/a | yes |
| vpc\_config | VPC configuration for lambda | map | n/a | yes |
| cloudwatch\_log\_retention | Cloudwatch log retention | string | `"90"` | no |
| cloudwatch\_log\_subscription | cloudwatch log stream configuration | map | `<map>` | no |
| description | lambda function description | string | `"Managed by Terraform"` | no |
| enable\_cloudwatch\_log\_subscription | Enable cloudwatch log subscription | string | `"false"` | no |
| environment | lambda environment variables | map | `<map>` | no |
| layers | List of layers for this lambda function | list | `<list>` | no |
| memory\_size | lambda function memory size | string | `"128"` | no |
| publish | Publish lambda function | string | `"false"` | no |
| reserved\_concurrent\_executions | Reserved concurrent executions  for this lambda function | string | `"-1"` | no |
| runtime | lambda function runtime | string | `"nodejs12.x"` | no |
| tags | Tags for this lambda function | map | `<map>` | no |
| timeout | lambda function runtime | string | `"300"` | no |
| tracing\_config | https://www.terraform.io/docs/providers/aws/r/lambda\_function.html | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS lambda arn |
| dlq\_arn | AWS lambda DLQ arn |
| dlq\_url | AWS lambda DLQ url |
| invoke\_arn | AWS lambda invoke\_arn |
| last\_modified | AWS lambda last\_modified |
| qualified\_arn | AWS lambda qualified\_arn |
| queue\_arn | AWS lambda SQS arn |
| queue\_url | AWS lambda SQS url |
| source\_code\_hash | AWS lambda source\_code\_hash |
| source\_code\_size | AWS lambda source\_code\_size |
| version | AWS lambda version |

