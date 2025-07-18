##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  # public nat count is the count of var.nat_settings.allocation_ids, unless var.nat_settings.nat_count > 0
  public_nat_count = var.nat_settings.connectivity_type == "public" ? (
    var.nat_settings.nat_count > 0 ? var.nat_settings.nat_count : length(var.nat_settings.allocation_ids)
  ) : 0
  private_nat_count = var.nat_settings.connectivity_type == "private" ? (
    var.nat_settings.nat_count > 0 ? var.nat_settings.nat_count : length(var.nat_settings.subnet_ids)
  ) : 0
}

resource "aws_nat_gateway" "public" {
  count                          = local.public_nat_count
  connectivity_type              = var.nat_settings.connectivity_type
  allocation_id                  = try(var.nat_settings.allocation_ids[count.index], var.nat_settings.configurations[count.index].allocation_id)
  private_ip                     = try(var.nat_settings.private_ips[count.index], var.nat_settings.configurations[count.index].private_ip)
  subnet_id                      = try(var.nat_settings.subnet_ids[count.index], var.nat_settings.configurations[count.index].subnet_id)
  secondary_allocation_ids       = try(var.nat_settings.configurations[count.index].secondary_allocation_ids, null)
  secondary_private_ip_addresses = try(var.nat_settings.configurations[count.index].secondary_private_ips, null)
  tags = merge({
    Name = "${try(var.nat_settings.configurations[count.index].name_prefix, "nat")}-${local.system_name}-public"
  }, local.all_tags)
}

resource "aws_nat_gateway" "private" {
  count                              = local.private_nat_count
  connectivity_type                  = var.nat_settings.connectivity_type
  private_ip                         = try(var.nat_settings.private_ips[count.index], var.nat_settings.configurations[count.index].private_ip)
  subnet_id                          = try(var.nat_settings.subnet_ids[count.index], var.nat_settings.configurations[count.index].subnet_id)
  secondary_private_ip_address_count = try(var.nat_settings.configurations[count.index].secondary_private_ip_count, null)
  secondary_private_ip_addresses     = try(var.nat_settings.configurations[count.index].secondary_private_ips, null)
  tags = merge({
    Name = "${try(var.nat_settings.configurations[count.index].name_prefix, "nat")}-${local.system_name}-private"
  }, local.all_tags)
}

resource "aws_ec2_tag" "tags_public" {
  for_each = merge([
    for index in range(local.public_nat_count) : {
      for k, v in merge(local.all_tags, {
        Name = "${try(var.nat_settings.configurations[index].name_prefix, "nat")}-${local.system_name}-public"
        }) : "${index}-${k}" => {
        index     = index
        tag_key   = k
        tag_value = v
      }
    }
  ]...)
  resource_id = aws_nat_gateway.public[each.value.index].network_interface_id
  key         = each.value.tag_key
  value       = each.value.tag_value
}

resource "aws_ec2_tag" "tags_private" {
  for_each = merge([
    for index in range(local.private_nat_count) : {
      for k, v in merge(local.all_tags, {
        Name = "${try(var.nat_settings.configurations[index].name_prefix, "nat")}-${local.system_name}-private"
        }) : "${index}-${k}" => {
        index     = index
        tag_key   = k
        tag_value = v
      }
    }
  ]...)
  resource_id = aws_nat_gateway.private[each.value.index].network_interface_id
  key         = each.value.tag_key
  value       = each.value.tag_value
}