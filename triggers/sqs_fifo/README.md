## Required Inputs

The following input variables are required:

### lambda\_function\_arn

Description: Lambda arn

Type: `string`

### sqs\_config

Description: SQS queue configuration

Type: `map`

### tags

Description: Tags

Type: `map`

## Optional Inputs

The following input variables are optional (have default values):

### enable

Description: 0 to disable and 1 to enable this module

Type: `string`

Default: `"0"`

## Outputs

The following outputs are exported:

### dlq\_arn

Description: Dead Letter Queue arn

### dlq\_id

Description: Dead Leter Queue endpoint

### queue\_arn

Description: SQS arn

### queue\_id

Description: SQS endpoint

