##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "nat_gateway_public" {
  description = "Map of the created public NAT Gateways keyed by gateway ID, each entry holding its id, allocation_id, subnet_id, private_ip, network_interface_id and Name tag. Null when connectivity_type is not \"public\"."
  value = var.nat_settings.connectivity_type != "public" ? null : {
    for nat in aws_nat_gateway.public : nat.id => {
      id                   = nat.id
      allocation_id        = nat.allocation_id
      subnet_id            = nat.subnet_id
      private_ip           = nat.private_ip
      network_interface_id = nat.network_interface_id
      name                 = nat.tags["Name"]
    }
  }
}

output "nat_gateway_private" {
  description = "Map of the created private NAT Gateways keyed by gateway ID, each entry holding its id, subnet_id, private_ip, network_interface_id and Name tag. Null when connectivity_type is not \"private\"."
  value = var.nat_settings.connectivity_type != "private" ? null : {
    for nat in aws_nat_gateway.private : nat.id => {
      id                   = nat.id
      subnet_id            = nat.subnet_id
      private_ip           = nat.private_ip
      network_interface_id = nat.network_interface_id
      name                 = nat.tags["Name"]
    }
  }
}

output "nat_gateway_ids" {
  description = "List of the IDs of all NAT Gateways created by this module, regardless of connectivity type."
  value       = concat(aws_nat_gateway.public[*].id, aws_nat_gateway.private[*].id)
}

output "nat_gateway_public_ips" {
  description = "List of the public IPv4 addresses of the public NAT Gateways, empty when connectivity_type is \"private\"."
  value       = aws_nat_gateway.public[*].public_ip
}

output "nat_gateway_private_ips" {
  description = "List of the primary private IPv4 addresses of all NAT Gateways created by this module."
  value       = concat(aws_nat_gateway.public[*].private_ip, aws_nat_gateway.private[*].private_ip)
}

output "nat_gateway_network_interface_ids" {
  description = "List of the ENI IDs attached to all NAT Gateways created by this module, useful for flow log and security tooling lookups."
  value       = concat(aws_nat_gateway.public[*].network_interface_id, aws_nat_gateway.private[*].network_interface_id)
}
