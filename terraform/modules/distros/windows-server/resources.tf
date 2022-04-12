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
        ansible_connection                   = "winrm"
        ansible_port                         = "5986"
        ansible_winrm_server_cert_validation = "ignore"
        ansible_user                         = local.distro_config.winrm_user
        win_user                             = local.distro_config.winrm_user
        ansible_password                     = local.distro_config.winrm_password
        win_password                         = local.distro_config.winrm_password
      }
    )
  )

  provisioning_command     = "ansible-playbook -i $PUBLIC_IP /opt/automation/tools/ansible/playbooks/windows.yml --extra-vars='${local.extra_vars}'"
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

resource "aws_instance" "windows_server" {
  ami                    = data.aws_ami.current.image_id
  instance_type          = lookup(local.input_config.os, "size", local.distro_config.instance_type)
  subnet_id              = local.deploy_config.instance_subnet_id
  key_name               = local.deploy_config.key_name
  vpc_security_group_ids = [local.deploy_config.security_group_id]

  tags = {
    Name = "${local.deploy_config.base_name}-${local.environment_config.name}-${local.node_config.hostname}"
  }

  user_data = <<EOF
<powershell>
$admin = [adsi]("WinNT://./${local.distro_config.winrm_user}, user")
$admin.PSBase.Invoke("SetPassword", "${local.distro_config.winrm_password}")
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Url = 'https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'
$PSFile = 'C:\ConfigureRemotingForAnsible.ps1'
Invoke-WebRequest -Uri $Url -OutFile $PSFile
C:\ConfigureRemotingForAnsible.ps1
</powershell>
EOF

  provisioner "remote-exec" {
    inline = ["echo booted"]

    connection {
      type     = "winrm"
      user     = local.distro_config.winrm_user
      password = local.distro_config.winrm_password
      host     = self.public_ip
      port     = 5986
      insecure = true
      https    = true
      timeout  = "20m"
    }
  }
}

resource "null_resource" "ansible" {

  triggers = {
    command = replace(local.provisioning_command, "$PUBLIC_IP", "'${aws_instance.windows_server.public_ip},'")
  }

  provisioner "local-exec" {
    command = replace(local.provisioning_command, "$PUBLIC_IP", "'${aws_instance.windows_server.public_ip},'")
  }
}
