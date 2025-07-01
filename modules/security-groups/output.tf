output "alb_security_group_id" {
  description = "ALB 보안 그룹 ID"
  value       = aws_security_group.alb.id
}

output "bastion_security_group_id" {
  description = "Bastion Host 보안 그룹 ID"
  value       = aws_security_group.bastion.id
}

output "web_security_group_id" {
  description = "Web Server 보안 그룹 ID"
  value       = aws_security_group.web.id
}

output "database_security_group_id" {
  description = "RDS 보안 그룹 ID"
  value       = aws_security_group.database.id
}
