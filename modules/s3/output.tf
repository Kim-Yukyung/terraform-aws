output "bucket_name" {
  description = "S3 버킷 이름"
  value       = aws_s3_bucket.web.bucket
}

output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.web.arn
}

output "bucket_id" {
  description = "S3 버킷 ID"
  value       = aws_s3_bucket.web.id
}

output "bucket_domain_name" {
  description = "S3 버킷 도메인 이름"
  value       = aws_s3_bucket.web.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "S3 버킷의 지역별 도메인 이름"
  value       = aws_s3_bucket.web.bucket_regional_domain_name
}

output "website_endpoint" {
  description = "S3 정적 웹사이트 엔드포인트"
  value       = aws_s3_bucket_website_configuration.web.website_endpoint
}
