##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "aws_nat_gateway" "public" {
  count                          = var.nat_settings.connectivity_type == "public" ? max(length(var.nat_settings.allocation_ids), var.nat_settings.nat_count) : 0
  connectivity_type              = var.nat_settings.connectivity_type
  allocation_id                  = var.nat_settings.allocation_ids[count.index]
  private_ip                     = try(var.nat_settings.private_ips[count.index], null)
  subnet_id                      = var.nat_settings.subnet_ids[count.index]
  secondary_allocation_ids       = var.nat_settings.secondary_allocation_ids
  secondary_private_ip_addresses = var.nat_settings.secondary_private_ips
  tags = merge({
    Name = "nat-${local.system_name}"
  }, local.all_tags)
}

resource "aws_nat_gateway" "private" {
  count                              = var.nat_settings.connectivity_type == "private" ? max(length(var.nat_settings.subnet_ids), var.nat_settings.nat_count) : 0
  connectivity_type                  = var.nat_settings.connectivity_type
  private_ip                         = var.nat_settings.private_ips[count.index]
  subnet_id                          = var.nat_settings.subnet_ids[count.index]
  secondary_private_ip_address_count = var.nat_settings.secondary_private_ip_count
  secondary_private_ip_addresses     = var.nat_settings.secondary_private_ips
  tags = merge({
    Name = "nat-${local.system_name}"
  }, local.all_tags)
}