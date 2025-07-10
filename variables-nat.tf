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
    nat_count                  = optional(number, -1)
    connectivity_type          = optional(string, "public")
    configurations            = optional(list(object({
      subnet_id                 = optional(string, null)
      private_ip                = optional(string, null)
      allocation_id             = optional(string, null)
      secondary_allocation_ids  = optional(list(string), null)
      secondary_private_ips     = optional(list(string), null)
      secondary_private_ip_count = optional(number, null)
    })), [])
    subnet_ids                 = optional(list(string), [])
    private_ips                = optional(list(string), [])
    allocation_ids             = optional(list(string), [])
  })
  default = {}
}
