provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

locals {
  wdc  = { for key, val in var.config : key => val if val.type == "windows_standalone" }
  lnxs = { for key, val in var.config : key => val if val.type == "linux_standalone" }

  deploy_config = {
    key_name           = module.core.key_name
    private_key_pem    = module.core.private_key_pem
    security_group_id  = module.core.security_group_id
    base_name          = module.core.base_name
    instance_subnet_id = module.core.instance_subnet_id
    filename_key_pem   = "${abspath(path.root)}/key.pem"
  }
}


module "core" {
  source        = "../modules/core"
  project_name  = var.project_name
  vpc_id        = data.aws_vpc.default.id
}

module "env-windows-standalone" {
  source = "../modules/environments/windows-standalone"

  for_each = local.wdc

  config = {
    input_config = each.value
    environment_config = {
      name = each.key
    }
    deploy_config = local.deploy_config
  }
}

module "env-linux-standalone" {
  source = "../modules/environments/linux-standalone"

  for_each = local.lnxs

  config = {
    input_config = each.value
    environment_config = {
      name = each.key
    }
    deploy_config = local.deploy_config
  }
}
