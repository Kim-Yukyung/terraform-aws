# Bastion 호스트 출력값
output "bastion_public_ip" {
  description = "Bastion 호스트 퍼블릭 IP"
  value       = module.bastion.bastion_public_ip
}

output "bastion_eip" {
  description = "Bastion 호스트 Elastic IP"
  value       = module.bastion.bastion_eip
}

output "bastion_ssh_command" {
  description = "Bastion 호스트 SSH 접속 명령어"
  value       = module.bastion.ssh_command
}
