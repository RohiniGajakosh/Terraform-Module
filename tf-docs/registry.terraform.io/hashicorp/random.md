# Provider registry.terraform.io/hashicorp/random

## Resource random_id
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| b64_std | no | yes | string | The generated id presented in base64 without additional transformations. |
| b64_url | no | yes | string | The generated id presented in base64, using the URL-friendly character set: case-sensitive letters, digits and the characters `_` and `-`. |
| byte_length | yes | no | number | The number of random bytes to produce. The minimum value is 1, which produces eight bits of randomness. |
| dec | no | yes | string | The generated id presented in non-padded decimal digits. |
| hex | no | yes | string | The generated id presented in padded hexadecimal digits. This result will always be twice as long as the requested byte length. |
| id | no | yes | string | The generated id presented in base64 without additional transformations or prefix. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| prefix | no | no | string | Arbitrary string to prefix the output value with. This string is supplied as-is, meaning it is not guaranteed to be URL-safe or base64 encoded. |

## Resource random_integer
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| id | no | yes | string | The string representation of the integer result. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| max | yes | no | number | The maximum inclusive value of the range. |
| min | yes | no | number | The minimum inclusive value of the range. |
| result | no | yes | number | The random integer result. |
| seed | no | no | string | A custom seed to always produce the same value. |

## Resource random_password
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| bcrypt_hash | no | yes | string | A bcrypt hash of the generated random string. |
| id | no | yes | string | A static value used internally by Terraform, this should not be referenced in configurations. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| length | yes | no | number | The length of the string desired. The minimum value for length is 1 and, length must also be >= (`min_upper` + `min_lower` + `min_numeric` + `min_special`). |
| lower | no | yes | bool | Include lowercase alphabet characters in the result. Default value is `true`. |
| min_lower | no | yes | number | Minimum number of lowercase alphabet characters in the result. Default value is `0`. |
| min_numeric | no | yes | number | Minimum number of numeric characters in the result. Default value is `0`. |
| min_special | no | yes | number | Minimum number of special characters in the result. Default value is `0`. |
| min_upper | no | yes | number | Minimum number of uppercase alphabet characters in the result. Default value is `0`. |
| number | no | yes | bool | Include numeric characters in the result. Default value is `true`. **NOTE**: This is deprecated, use `numeric` instead. |
| numeric | no | yes | bool | Include numeric characters in the result. Default value is `true`. |
| override_special | no | no | string | Supply your own list of special characters to use for string generation.  This overrides the default character list in the special argument.  The `special` argument must still be set to true for any overwritten characters to be used in generation. |
| result | no | yes | string | The generated random string. |
| special | no | yes | bool | Include special characters in the result. These are `!@#$%&*()-_=+[]{}<>:?`. Default value is `true`. |
| upper | no | yes | bool | Include uppercase alphabet characters in the result. Default value is `true`. |

## Resource random_pet
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| id | no | yes | string | The random pet name. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| length | no | yes | number | The length (in words) of the pet name. Defaults to 2 |
| prefix | no | no | string | A string to prefix the name with. |
| separator | no | yes | string | The character to separate words in the pet name. Defaults to "-" |

## Resource random_shuffle
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| id | no | yes | string | A static value used internally by Terraform, this should not be referenced in configurations. |
| input | yes | no | ['list', 'string'] | The list of strings to shuffle. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| result | no | yes | ['list', 'string'] | Random permutation of the list of strings given in `input`. |
| result_count | no | no | number | The number of results to return. Defaults to the number of items in the `input` list. If fewer items are requested, some elements will be excluded from the result. If more items are requested, items will be repeated in the result but not more frequently than the number of items in the input list. |
| seed | no | no | string | Arbitrary string with which to seed the random number generator, in order to produce less-volatile permutations of the list.  **Important:** Even with an identical seed, it is not guaranteed that the same permutation will be produced across different versions of Terraform. This argument causes the result to be *less volatile*, but not fixed for all time. |

## Resource random_string
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| id | no | yes | string | The generated random string. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| length | yes | no | number | The length of the string desired. The minimum value for length is 1 and, length must also be >= (`min_upper` + `min_lower` + `min_numeric` + `min_special`). |
| lower | no | yes | bool | Include lowercase alphabet characters in the result. Default value is `true`. |
| min_lower | no | yes | number | Minimum number of lowercase alphabet characters in the result. Default value is `0`. |
| min_numeric | no | yes | number | Minimum number of numeric characters in the result. Default value is `0`. |
| min_special | no | yes | number | Minimum number of special characters in the result. Default value is `0`. |
| min_upper | no | yes | number | Minimum number of uppercase alphabet characters in the result. Default value is `0`. |
| number | no | yes | bool | Include numeric characters in the result. Default value is `true`. **NOTE**: This is deprecated, use `numeric` instead. |
| numeric | no | yes | bool | Include numeric characters in the result. Default value is `true`. |
| override_special | no | no | string | Supply your own list of special characters to use for string generation.  This overrides the default character list in the special argument.  The `special` argument must still be set to true for any overwritten characters to be used in generation. |
| result | no | yes | string | The generated random string. |
| special | no | yes | bool | Include special characters in the result. These are `!@#$%&*()-_=+[]{}<>:?`. Default value is `true`. |
| upper | no | yes | bool | Include uppercase alphabet characters in the result. Default value is `true`. |

## Resource random_uuid
| Name | Required | Computed | Type | Description |
|------|----------|----------|------|-------------|
| id | no | yes | string | The generated uuid presented in string format. |
| keepers | no | no | ['map', 'string'] | Arbitrary map of values that, when changed, will trigger recreation of resource. See [the main provider documentation](../index.html) for more information. |
| result | no | yes | string | The generated uuid presented in string format. |
