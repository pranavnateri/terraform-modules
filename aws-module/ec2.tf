resource "aws_instance" "ec2_instance" {
  depends_on             = [aws_vpc.vpc_name, aws_subnet.tier1, aws_subnet.tier2, aws_subnet.tier3]
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = flatten(aws_subnet.tier2.*.id)[0]
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  key_name               = aws_key_pair.key.key_name
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = {
    Name = "${local.env_selected}-${var.service_name}-${var.region}"
  }
}