variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

variable "vpc_id" {
  description = "보안 그룹이 생성될 VPC ID"
  type        = string
}

variable "allowed_alb_cidr_blocks" {
  description = "ALB 접근을 허용할 CIDR 블록 리스트"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidr_blocks" {
  description = "Bastion Host SSH 접속을 허용할 CIDR 블록 리스트"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
