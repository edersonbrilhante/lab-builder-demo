output "environments" {
  description = "The environments"
  value = merge(
    {for key, env in module.env-windows-standalone : key => env}, 
    {for key, env in module.env-linux-standalone : key => env}
  )
}

output "region" {
  description = "The AWS region."
  value       = var.region
}
