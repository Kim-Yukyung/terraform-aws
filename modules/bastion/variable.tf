variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

variable "ami_id" {
  description = "Bastion 호스트 AMI ID"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Bastion 호스트 인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair 이름"
  type        = string
  default     = ""
}

variable "public_subnet_id" {
  description = "Bastion 호스트가 배치될 퍼블릭 서브넷 ID"
  type        = string
}

variable "security_group_ids" {
  description = "Bastion 호스트에 연결할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "user_data_script" {
  description = "Bastion 호스트 초기화 스크립트"
  type        = string
  default     = ""
}

# EBS Variables
variable "root_volume_size" {
  description = "루트 볼륨 크기 (GB)"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "루트 볼륨 타입"
  type        = string
  default     = "gp3"
}

variable "encrypt_root_volume" {
  description = "루트 볼륨 암호화 여부"
  type        = bool
  default     = true
}

# Monitoring
variable "enable_detailed_monitoring" {
  description = "CloudWatch 상세 모니터링 활성화 여부"
  type        = bool
  default     = false
}

# Elastic IP
variable "create_eip" {
  description = "Elastic IP 생성 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
