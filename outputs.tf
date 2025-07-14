##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "nat_gateway_public" {
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