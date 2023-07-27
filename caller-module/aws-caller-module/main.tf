module "intuitive-network" {
  source              = "../../aws-module"
  organization        = var.organization
  env                 = var.env
  region              = var.region
  cidr_block          = var.cidr_block
  subnet_tier1_prefix = var.subnet_tier1_prefix
  subnet_tier1_range  = var.subnet_tier1_range
  subnet_tier2_prefix = var.subnet_tier2_prefix
  subnet_tier2_range  = var.subnet_tier2_range
  subnet_tier3_prefix = var.subnet_tier3_prefix
  subnet_tier3_range  = var.subnet_tier3_range
  ami_id              = var.ami_id
  volume_type         = var.volume_type
  additional_tags     = var.additional_tags
}
