output "ids" {
  description = "The ID of the instance"
  value = merge(
    { for ec2 in module.windows-domain-controller : ec2.tags_all.Name => ec2.id },
    { for ec2 in module.windows-server-member : ec2.tags_all.Name => ec2.id }
  )
}

output "public_ips" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = merge(
    { for ec2 in module.windows-domain-controller : ec2.tags_all.Name => ec2.public_ip },
    { for ec2 in module.windows-server-member : ec2.tags_all.Name => ec2.public_ip }
  )
}

output "private_ips" {
  description = "The private IP address assigned to the instance."
  value = merge(
    { for ec2 in module.windows-domain-controller : ec2.tags_all.Name => ec2.private_ip },
    { for ec2 in module.windows-server-member : ec2.tags_all.Name => ec2.private_ip }
  )
}

output "provisioning_commands" {
  description = "The ansible command to the instance."
  value = merge(
    { for ec2 in module.windows-domain-controller : ec2.tags_all.Name => ec2.provisioning_command },
    { for ec2 in module.windows-server-member : ec2.tags_all.Name => ec2.provisioning_command }
  )
}