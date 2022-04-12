
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "default" {
  name   = local.base_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = concat(["${chomp(data.http.myip.body)}/32"])
  }
  
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = concat(["${chomp(data.http.myip.body)}/32"])
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = concat(["${chomp(data.http.myip.body)}/32"])
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat(["${chomp(data.http.myip.body)}/32"])
  }
  
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
