variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "S3 버킷의 지역별 도메인 이름"
  type        = string
}

variable "domain_names" {
  description = "CloudFront 배포에 연결할 도메인 이름 목록"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM 인증서 ARN"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
