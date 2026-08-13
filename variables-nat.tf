##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Gateways are created from index-aligned lists: index 0 of subnet_ids, allocation_ids, private_ips and
# configurations all describe the same gateway. Every list that is supplied must therefore hold at least as
# many entries as the resolved gateway count, and the entries must stay in a stable order — the resources are
# count-based, so inserting or reordering an element re-creates every gateway from that index onwards.
#
# nat_settings: # (Optional) NAT Gateway settings. Default: {} (no NAT Gateway is created)
#   nat_count: -1                # (Optional) Number of NAT Gateways to create. Default: -1
#                                #            When <= 0 the count is derived from the length of allocation_ids
#                                #            (connectivity_type = "public") or subnet_ids (connectivity_type = "private").
#                                #            When > 0 it wins over the list lengths, so it must not exceed them.
#   connectivity_type: "public"  # (Optional) NAT Gateway connectivity type. Values: "public" | "private". Default: "public"
#                                #            "public"  -> internet egress, requires an Elastic IP allocation per gateway.
#                                #            "private" -> VPC-to-VPC / on-premises egress, no Elastic IP is used.
#                                #            Changing it on an existing deployment destroys and re-creates every
#                                #            gateway, because each type is backed by a separate resource.
#   subnet_ids: []               # (Optional) Subnet IDs, one per NAT Gateway, indexed in order. Default: []
#                                #            Takes precedence over configurations[*].subnet_id.
#                                #            Public gateways must be placed in PUBLIC subnets (a subnet routed to
#                                #            an Internet Gateway); private gateways sit in private subnets.
#                                #            When the Terragrunt VPC dependency is enabled this list is injected
#                                #            automatically from the VPC module outputs.
#   allocation_ids: []           # (Optional) Elastic IP allocation IDs, one per NAT Gateway, indexed in order. Default: []
#                                #            Only used when connectivity_type = "public". Takes precedence over
#                                #            configurations[*].allocation_id.
#   private_ips: []              # (Optional) Primary private IPv4 addresses, one per NAT Gateway, indexed in order. Default: []
#                                #            Must belong to the CIDR of the matching subnet. Takes precedence over
#                                #            configurations[*].private_ip.
#                                #            When omitted AWS assigns an address from the subnet automatically.
#   configurations: []           # (Optional) Per-gateway configuration list, indexed in the same order as the lists
#                                #            above. Use it when gateways need different names or secondary addresses.
#                                #            Default: []
#     - name_prefix: "nat"                 # (Optional) Prefix of the gateway Name tag, rendered as
#                                          #            "<name_prefix>-<system_name>-<connectivity_type>". Default: "nat"
#       subnet_id: "subnet-0123456789"     # (Optional) Subnet ID the gateway is placed in. Default: null
#                                          #            Ignored when subnet_ids has a value at the same index.
#       allocation_id: "eipalloc-0123456"  # (Optional) Elastic IP allocation ID. Default: null
#                                          #            Required for public gateways, ignored when allocation_ids has a
#                                          #            value at the same index.
#       private_ip: "10.0.1.100"           # (Optional) Primary private IPv4 address of the gateway. Default: null
#                                          #            Ignored when private_ips has a value at the same index.
#       secondary_allocation_ids: []       # (Optional) Additional Elastic IP allocation IDs assigned to the gateway.
#                                          #            Public gateways only. Default: null
#       secondary_private_ips: []          # (Optional) Additional private IPv4 addresses assigned to the gateway.
#                                          #            Conflicts with secondary_private_ip_count. Default: null
#       secondary_private_ip_count: 2      # (Optional) Number of secondary private IPv4 addresses to allocate
#                                          #            automatically. Private gateways only, conflicts with
#                                          #            secondary_private_ips. Default: null
variable "nat_settings" {
  description = "(Optional) NAT Gateway settings, supports public and private connectivity types. Default: {}"
  type = object({
    nat_count         = optional(number, -1)
    connectivity_type = optional(string, "public")
    configurations = optional(list(object({
      name_prefix                = optional(string, "nat")
      subnet_id                  = optional(string, null)
      private_ip                 = optional(string, null)
      allocation_id              = optional(string, null)
      secondary_allocation_ids   = optional(list(string), null)
      secondary_private_ips      = optional(list(string), null)
      secondary_private_ip_count = optional(number, null)
    })), [])
    subnet_ids     = optional(list(string), [])
    private_ips    = optional(list(string), [])
    allocation_ids = optional(list(string), [])
  })
  default = {}

  validation {
    condition     = contains(["public", "private"], var.nat_settings.connectivity_type)
    error_message = "The nat_settings.connectivity_type must be either \"public\" or \"private\"."
  }
}
