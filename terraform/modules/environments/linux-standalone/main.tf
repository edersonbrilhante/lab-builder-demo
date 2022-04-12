module "constants" {
  source = "../../constants"
}

locals {
  input_config       = var.config.input_config
  deploy_config      = var.config.deploy_config
  environment_config = var.config.environment_config
  servers            = { for key, val in local.input_config.nodes : key => val if val.type == "linux" }
}

module "linux" {
  source = "../../distros/linux-server"

  for_each = local.servers

  config = {
    deploy_config      = local.deploy_config
    environment_config = local.environment_config
    input_config       = each.value
    node_config = {
      distro_config = module.constants.amis["${each.value.os.distro}-${each.value.os.version}"]
      hostname      = each.key
    }
  }
}
