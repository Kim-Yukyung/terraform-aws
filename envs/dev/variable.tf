variable "aws_profile" {
  type    = string
  default = null
}

# 데이터베이스 인증 정보
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
