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

# S3 출력값
output "s3_bucket_name" {
  description = "S3 버킷 이름"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 버킷 ARN"
  value       = module.s3.bucket_arn
}

output "s3_website_endpoint" {
  description = "S3 정적 웹사이트 엔드포인트"
  value       = module.s3.website_endpoint
}

# CloudFront 출력값
output "cloudfront_distribution_id" {
  description = "CloudFront 배포 ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront 배포 도메인 이름"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_distribution_arn" {
  description = "CloudFront 배포 ARN"
  value       = module.cloudfront.distribution_arn
}
