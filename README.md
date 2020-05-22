## Required Inputs

The following input variables are required:

### file\_name

Description: lambda function filename name

Type: `string`

### function\_name

Description: lambda function name

Type: `string`

### handler

Description: lambda function handler

Type: `string`

### region

Description: AWS region

Type: `string`

### role

Description: lambda function role

Type: `string`

### trigger

Description: trigger configuration for this lambda function

Type: `map`

### vpc\_config

Description: VPC configuration for lambda

Type: `map`

## Optional Inputs

The following input variables are optional (have default values):

### cloudwatch\_log\_retention

Description: Cloudwatch log retention

Type: `string`

Default: `"90"`

### cloudwatch\_log\_subscription

Description: cloudwatch log stream configuration

Type: `map`

Default: `<map>`

### description

Description: lambda function description

Type: `string`

Default: `"Managed by Terraform"`

### enable\_cloudwatch\_log\_subscription

Description: Enable cloudwatch log subscription

Type: `string`

Default: `"false"`

### environment

Description: lambda environment variables

Type: `map`

Default: `<map>`

### layers

Description: List of layers for this lambda function

Type: `list`

Default: `<list>`

### memory\_size

Description: lambda function memory size

Type: `string`

Default: `"128"`

### publish

Description: Publish lambda function

Type: `string`

Default: `"false"`

### reserved\_concurrent\_executions

Description: Reserved concurrent executions  for this lambda function

Type: `string`

Default: `"-1"`

### runtime

Description: lambda function runtime

Type: `string`

Default: `"nodejs12.x"`

### tags

Description: Tags for this lambda function

Type: `map`

Default: `<map>`

### timeout

Description: lambda function runtime

Type: `string`

Default: `"300"`

### tracing\_config

Description: https://www.terraform.io/docs/providers/aws/r/lambda\_function.html

Type: `map`

Default: `<map>`

## Outputs

The following outputs are exported:

### arn

Description: AWS lambda arn

### dlq\_arn

Description: AWS lambda DLQ arn

### dlq\_url

Description: AWS lambda DLQ url

### invoke\_arn

Description: AWS lambda invoke\_arn

### last\_modified

Description: AWS lambda last\_modified

### qualified\_arn

Description: AWS lambda qualified\_arn

### queue\_arn

Description: AWS lambda SQS arn

### queue\_url

Description: AWS lambda SQS url

### source\_code\_hash

Description: AWS lambda source\_code\_hash

### source\_code\_size

Description: AWS lambda source\_code\_size

### version

Description: AWS lambda version

