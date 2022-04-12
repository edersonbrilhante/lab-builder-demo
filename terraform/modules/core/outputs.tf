output "key_name" {
  value = module.key_pair.key_pair_key_name
}

output "security_group_id" {
  value = aws_security_group.default.id
}

output "base_name" {
  value = local.base_name
}

output "instance_subnet_id" {
  value = local.instance_subnet_id
}

output "private_key_pem" {
  description = "The Private Key PEM."
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}
