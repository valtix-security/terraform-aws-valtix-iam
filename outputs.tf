output "valtix_controller_role_arn" {
  description = "this outputs the valtix-controller IAM role ARN"
  value       = module.iam.valtix_controller_role.arn
}

output "valtix_firewall_role_name" {
  description = "this outputs the name of the Valtix firewall role"
  value       = module.iam.valtix_firewall_role_name
}
