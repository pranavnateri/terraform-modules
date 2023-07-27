locals {
  additional_tags = var.additional_tags
  security_list   = var.security_list
  env_selected    = lookup(local.env_select, var.Environment)
  env_select      = var.env_select
  resource_tags   = merge(local.default_tags, var.additional_tags)
  default_tags = {
    Name        = "${local.env_selected}-${var.service_name}-${var.region}"
    Service     = var.service_name
    Environment = var.Environment
  }
}