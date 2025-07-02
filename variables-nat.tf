##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "nat_settings" {
  description = "(optional) Map of settings for the NAT Gateway, defaults to empty map"
  type = object({
    connectivity_type          = optional(string, "public")
    allocation_ids             = optional(list(string), [])
    subnet_ids                 = optional(list(string), [])
    private_ips                = optional(list(string), [])
    secondary_allocation_ids   = optional(list(string), null)
    secondary_private_ips      = optional(list(string), null)
    secondary_private_ip_count = optional(number, null)
  })
  default = {}
}
