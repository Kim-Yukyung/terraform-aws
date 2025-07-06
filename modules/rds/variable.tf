variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

variable "db_username" {
  description = "RDS 사용자 이름"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "RDS 서브넷 그룹 이름"
  type        = string
}

variable "db_security_group_id" {
  description = "RDS 보안 그룹 ID"
  type        = string
}

# 엔진 설정
variable "engine" {
  description = "데이터베이스 엔진"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "데이터베이스 엔진 버전"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "publicly_accessible" {
  description = "RDS 공개 접근 가능 여부"
  type        = bool
  default     = false
}

# 스토리지 설정
variable "allocated_storage" {
  description = "초기 할당 스토리지 크기 (GB)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "스토리지 타입"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "스토리지 암호화 여부"
  type        = bool
  default     = true
}

variable "max_allocated_storage" {
  description = "최대 스토리지 크기 (GB)"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "다중 AZ 배포 여부"
  type        = bool
  default     = true
}

# 삭제 설정
variable "skip_final_snapshot" {
  description = "최종 스냅샷 생략 여부"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "삭제 보호 설정 여부"
  type        = bool
  default     = false
}

# 모니터링 설정
variable "monitoring_interval" {
  description = "CloudWatch 모니터링 간격 (초)"
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "모니터링을 위한 IAM 역할 ARN"
  type        = string
  default     = null
}

# 성능 인사이트
variable "performance_insights_enabled" {
  description = "성능 인사이트 활성화 여부"
  type        = bool
  default     = false
}

# 공통 태그
variable "common_tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
