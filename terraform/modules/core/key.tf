resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "1.0.0"

  key_name   = local.base_name
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "key_pem" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${abspath(path.root)}/key.pem"
  file_permission = "0400"
}
