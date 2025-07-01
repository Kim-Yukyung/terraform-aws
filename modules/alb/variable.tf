variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

variable "vpc_id" {
  description = "ALB를 생성할 VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "ALB에 연결할 서브넷 ID 목록"
  type        = list(string)
}

variable "security_group_ids" {
  description = "ALB에 적용할 보안 그룹 ID 리스트"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "삭제 보호 활성화 여부"
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "타겟 그룹 포트"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "타겟 그룹 프로토콜"
  type        = string
  default     = "HTTP"
}

variable "tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
