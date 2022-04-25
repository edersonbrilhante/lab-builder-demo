module "constants" {
  source = "../../constants"
}

locals {
  input_config       = var.config.input_config
  deploy_config      = var.config.deploy_config
  environment_config = var.config.environment_config
  domain_controllers = { for key, val in local.input_config.nodes : key => val if val.type == "windows_domain_controller" }
  server_members     = { for key, val in local.input_config.nodes : key => val if val.type == "windows_server_member" }
}

module "windows-domain-controller" {
  source = "../../distros/windows-server"

  for_each = local.domain_controllers

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

module "windows-server-member" {
  source = "../../distros/windows-server"

  for_each = local.server_members

  config = {
    deploy_config      = local.deploy_config
    environment_config = local.environment_config
    input_config       = each.value
    node_config = {
      distro_config             = module.constants.amis["${each.value.os.distro}-${each.value.os.version}"]
      hostname                  = each.key
      windows_domain_controller = try(module.windows-domain-controller[each.value.enabled_roles.windows_domain_client.server.address], null)
    }
  }
}
