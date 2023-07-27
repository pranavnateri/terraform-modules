resource "aws_security_group" "ec2-sg" {
  name_prefix = "${local.env_selected}-${var.service_name}-${var.region}-ec2-sg"
  description = "${local.env_selected}-${var.service_name}-${var.region}-ec2-sg"
  vpc_id      = aws_vpc.vpc_name.id
  tags        = local.resource_tags
  dynamic "ingress" {
    for_each = local.security_list
    content {
      from_port   = ingress.value["from_port"]
      protocol    = var.protocol
      to_port     = ingress.value["to_port"]
      cidr_blocks = [var.open_cidr]
    }
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.open_cidr]
  }
}