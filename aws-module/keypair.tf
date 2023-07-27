resource "aws_key_pair" "key" {
  key_name   = "${local.env_selected}-${var.service_name}-${var.region}-keypair"
  public_key = tls_private_key.key.public_key_openssh
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}