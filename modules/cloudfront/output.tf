output "distribution_id" {
  description = "CloudFront 배포 ID"
  value       = aws_cloudfront_distribution.web.id
}

output "distribution_arn" {
  description = "CloudFront 배포 ARN"
  value       = aws_cloudfront_distribution.web.arn
}

output "distribution_domain_name" {
  description = "CloudFront 배포 도메인 이름"
  value       = aws_cloudfront_distribution.web.domain_name
}

output "origin_access_control_id" {
  description = "Origin Access Control ID"
  value       = aws_cloudfront_origin_access_control.web.id
}

output "origin_access_control_arn" {
  description = "Origin Access Control ARN"
  value       = aws_cloudfront_origin_access_control.web.arn
}
