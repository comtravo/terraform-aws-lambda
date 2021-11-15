## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kinesis\_configuration | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping | <pre>map(object({<br>    batch_size                                      = number<br>    bisect_batch_on_function_error                  = bool<br>    destination_config__on_failure__destination_arn = string<br>    event_source_arn                                = string<br>    maximum_batching_window_in_seconds              = number<br>    maximum_record_age_in_seconds                   = number<br>    maximum_retry_attempts                          = number<br>    parallelization_factor                          = number<br>    starting_position                               = string<br>    starting_position_timestamp                     = string<br>    tumbling_window_in_seconds                      = number<br>  }))</pre> | `{}` | no |
| lambda\_function\_arn | Lambda arn | `string` | n/a | yes |

## Outputs

No output.
