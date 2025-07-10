## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.tags_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.tags_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_nat_gateway.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_nat_settings"></a> [nat\_settings](#input\_nat\_settings) | (optional) Map of settings for the NAT Gateway, defaults to empty map | <pre>object({<br/>    nat_count         = optional(number, -1)<br/>    connectivity_type = optional(string, "public")<br/>    configurations = optional(list(object({<br/>      subnet_id                  = optional(string, null)<br/>      private_ip                 = optional(string, null)<br/>      allocation_id              = optional(string, null)<br/>      secondary_allocation_ids   = optional(list(string), null)<br/>      secondary_private_ips      = optional(list(string), null)<br/>      secondary_private_ip_count = optional(number, null)<br/>    })), [])<br/>    subnet_ids     = optional(list(string), [])<br/>    private_ips    = optional(list(string), [])<br/>    allocation_ids = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_private"></a> [nat\_gateway\_private](#output\_nat\_gateway\_private) | n/a |
| <a name="output_nat_gateway_public"></a> [nat\_gateway\_public](#output\_nat\_gateway\_public) | n/a |
