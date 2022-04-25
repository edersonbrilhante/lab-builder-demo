locals {
  deploy_config      = var.config.deploy_config
  environment_config = var.config.environment_config
  input_config       = var.config.input_config
  node_config        = var.config.node_config

  distro_config = local.node_config.distro_config

  extra_vars = jsonencode(
    merge(
      local.node_config,
      local.input_config,
      {
        ansible_user                 = local.distro_config.ssh_username
        ansible_ssh_private_key_file = local.deploy_config.filename_key_pem
      }
    )
  )

  provisioning_command     = "ansible-playbook -i $PUBLIC_IP /opt/automation/tools/ansible/playbooks/bsd.yml --extra-vars='${local.extra_vars}'"
}

data "aws_ami" "current" {
  most_recent = true
  owners      = [local.distro_config.owner]

  filter {
    name   = "name"
    values = [local.distro_config.ami_regex]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "bsd_server" {
  ami                    = data.aws_ami.current.image_id
  instance_type          = lookup(local.input_config.os, "size", local.distro_config.instance_type)
  subnet_id              = local.deploy_config.instance_subnet_id
  key_name               = local.deploy_config.key_name
  vpc_security_group_ids = [local.deploy_config.security_group_id]

  tags = merge(
    local.deploy_config.tags,
    {
      Name = "${local.deploy_config.base_name}-${local.environment_config.name}-${local.node_config.hostname}"
    }
  )

  provisioner "remote-exec" {
    inline = ["echo booted"]

    connection {
      type        = "ssh"
      user        = local.distro_config.ssh_username
      host        = self.public_ip
      private_key = file(local.deploy_config.filename_key_pem)
    }
  }

}

resource "null_resource" "ansible" {

  triggers = {
    cmd_id = replace(local.provisioning_command, "$PUBLIC_IP", "'${aws_instance.bsd_server.public_ip},'")
  }

  provisioner "local-exec" {
    command = replace(local.provisioning_command, "$PUBLIC_IP", "'${aws_instance.bsd_server.public_ip},'")
  }
}
