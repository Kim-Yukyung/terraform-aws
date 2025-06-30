variable "prefix" {
  description = "자원 이름에 붙일 접두사"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC의 CIDR 블록"
  type        = string
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 설정 (key: az 식별자, value: { cidr, az })"

  type = map(object({
    cidr = string
    az   = string
  }))

  default = {}
}

variable "private_subnets" {
  description = "프라이빗 서브넷 설정 (key: az 식별자, value: { cidr, az })"

  type = map(object({
    cidr = string
    az   = string
  }))

  default = {}
}

variable "database_subnets" {
  description = "DB 서브넷 설정 (key: az 식별자, value: { cidr, az })"

  type = map(object({
    cidr = string
    az   = string
  }))

  default = {}
}

variable "enable_nat_gateway" {
  description = "프라이빗 서브넷에서 외부 접속이 필요할 경우 NAT Gateway 생성 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "모든 자원에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
