output "valtix_controller_role" {
  description = "this outputs the valtix-controller IAM role ARN"
  value       = aws_iam_role.valtix_controller_role
}

output "valtix_firewall_role_name" {
  description = "this outputs the name of the Valtix firewall role"
  value       = length(aws_iam_role.valtix_fw_role) > 0 ? aws_iam_role.valtix_fw_role[0].name : ""
}

output "valtix_cloudwatch_event_role" {
  value       = aws_iam_role.valtix_cloudwatch_event_role
}

