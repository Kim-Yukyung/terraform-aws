# Bastion Instance Outputs
output "bastion_instance_id" {
  description = "Bastion Host 인스턴스 ID"
  value       = aws_instance.bastion.id
}

output "bastion_instance_arn" {
  description = "Bastion Host 인스턴스 ARN"
  value       = aws_instance.bastion.arn
}

output "bastion_public_ip" {
  description = "Bastion Host 퍼블릭 IP"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Bastion Host 프라이빗 IP"
  value       = aws_instance.bastion.private_ip
}

# Elastic IP Outputs
output "bastion_eip" {
  description = "Bastion Host Elastic IP"
  value       = var.create_eip ? aws_eip.bastion[0].public_ip : null
}

output "bastion_eip_id" {
  description = "Bastion Host Elastic IP ID"
  value       = var.create_eip ? aws_eip.bastion[0].id : null
}

# AMI Information
output "ami_id" {
  description = "사용된 AMI ID"
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
}

output "ami_name" {
  description = "사용된 AMI 이름"
  value       = data.aws_ami.amazon_linux.name
}

# SSH 접속 정보
output "ssh_command" {
  description = "Bastion 호스트 SSH 접속 명령어"
  value       = var.key_name != "" ? "ssh -i ${var.key_name}.pem ec2-user@${var.create_eip ? aws_eip.bastion[0].public_ip : aws_instance.bastion.public_ip}" : "ssh ec2-user@${var.create_eip ? aws_eip.bastion[0].public_ip : aws_instance.bastion.public_ip}"
}
