# VPC and Subnets
resource "aws_vpc" "vpc_name" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc-${var.organization}-${var.env}-${var.region}"
  }
}


# Create 3 Tier 1 Subnet each in a different zone
resource "aws_subnet" "tier1" {
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = cidrsubnet(aws_vpc.vpc_name.cidr_block, var.subnet_tier1_prefix, var.subnet_tier1_range + count.index)
  vpc_id                  = aws_vpc.vpc_name.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = var.add_tags_enabled == "true" ? merge({
    Name = "subnet-${var.organization}-${var.env}-tier1-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "1"
    }, local.additional_tags) : {
    Name = "subnet-${var.organization}-${var.env}-tier1-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "1"
  }
}

# Create 3 Tier 2 Subnet each in a different zone

resource "aws_subnet" "tier2" {
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = cidrsubnet(aws_vpc.vpc_name.cidr_block, var.subnet_tier2_prefix, var.subnet_tier2_range + count.index)
  vpc_id                  = aws_vpc.vpc_name.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = var.add_tags_enabled == "true" ? merge({
    Name = "subnet-${var.organization}-${var.env}-tier2-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "2"
    }, local.additional_tags) : {
    Name = "subnet-${var.organization}-${var.env}-tier2-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "2"
  }
}


# Create 3 Tier 3 Subnet each in a different zone

resource "aws_subnet" "tier3" {
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = cidrsubnet(aws_vpc.vpc_name.cidr_block, var.subnet_tier3_prefix, var.subnet_tier3_range + count.index)
  vpc_id                  = aws_vpc.vpc_name.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = var.add_tags_enabled == "true" ? merge({
    Name = "subnet-${var.organization}-${var.env}-tier3-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "3"
    }, local.additional_tags) : {
    Name = "subnet-${var.organization}-${var.env}-tier3-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "3"
  }
}

# Internet gateway for the public subnet or Tier 1 subnets

resource "aws_internet_gateway" "internet_gateway_subnet1" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    Name = "ig-${var.organization}-${var.env}-tier1-${var.region}"
  }
}

# Create a new Route Table for the Tier 1 Subnets

resource "aws_route_table" "tier1_subnets_route_table" {
  vpc_id = aws_vpc.vpc_name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_subnet1.id
  }
  tags = {
    Name = "rt-${var.organization}-${var.env}-tier1-${var.region}"
  }
}

# Routing Table Associations for Tier1 subnets

resource "aws_route_table_association" "tier1_rt_association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.tier1.*.id, count.index)
  route_table_id = aws_route_table.tier1_subnets_route_table.id
}

# Create three NAT gateways with an elastic IPs for tier 2 three subnets in Tier 1
resource "aws_eip" "tier1_subnet_eip" {
  count  = length(data.aws_availability_zones.available.names)
  domain = "vpc"
  tags = {
    Name = "ng-eip-${var.organization}-${var.env}-tier1-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_nat_gateway" "tier1_nat_gateways" {
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = element(aws_eip.tier1_subnet_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.tier1.*.id, count.index)
  tags = {
    Name = "natg-${var.organization}-${var.env}-tier1-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Create three new Route Table for the tier 2 subnets and attach NAT gateways to it
resource "aws_route_table" "tier2_subnets_route_table" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.vpc_name.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.tier1_nat_gateways.*.id, count.index)
  }

  tags = {
    Name = "rt-${var.organization}-${var.env}-tier2-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Routing Table association for Tier 2 subnets
resource "aws_route_table_association" "tier2_route_association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.tier2.*.id, count.index)
  route_table_id = element(aws_route_table.tier2_subnets_route_table.*.id, count.index)
}

