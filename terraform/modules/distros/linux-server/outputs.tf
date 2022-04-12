output "id" {
  description = "The ID of the instance"
  value       = aws_instance.linux_server.id
}
output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_instance.linux_server.tags_all
}
output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance.linux_server.public_ip
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = aws_instance.linux_server.private_ip
}

output "provisioning_command" {
  description = "The ansible command for provisioning the instance."
  value       = base64encode(replace(local.provisioning_command, "$PUBLIC_IP", "'${aws_instance.linux_server.public_ip},'"))
}