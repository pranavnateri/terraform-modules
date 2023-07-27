# General Variables
variable "region" { default = "eu-west-1" }
variable "organization" { default = "intuitive" }
variable "env" { default = "dev" }
variable "instance_type" { default = "t2.medium" }
variable "volume_size" { default = "50" }
variable "Environment" { default = "dev" }
variable "service_name" { default = "interview" }
variable "volume_type" {}
variable "ami_id" {}
variable "security_list" {
  type = list(any)
  default = [
    {
      from_port = "80"
      to_port   = "80"
    },
    {
      from_port = "443"
      to_port   = "443"
    }
  ]
}
variable "protocol" { default = "TCP" }
variable "open_cidr" { default = "0.0.0.0/0" }

# Network Variables
variable "cidr_block" { default = "" }
variable "additional_tags" { type = map(any) }
variable "subnet_tier1_prefix" { default = "" }
variable "subnet_tier1_range" { default = "" }
variable "subnet_tier2_prefix" { default = "" }
variable "subnet_tier2_range" { default = "" }
variable "subnet_tier3_prefix" { default = "" }
variable "subnet_tier3_range" { default = "" }
variable "add_tags_enabled" { default = "false" }
variable "env_select" {
  type = map(any)
  default = {
    "stage" = "stg"
    "dev"   = "dev"
    "prod"  = "prd"
  }
}