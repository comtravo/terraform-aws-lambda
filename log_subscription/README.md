## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudwatch\_log\_subscription | Cloudwatch log subscription configuration | map | n/a | yes |
| lambda\_name | Lambda arn | string | n/a | yes |
| log\_group\_name | Lambda cloud watch logs stream name | string | n/a | yes |
| enable | 0 to disable and 1 to enable this module | string | `"0"` | no |

