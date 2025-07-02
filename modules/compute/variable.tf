variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

# Launch Template Variables
variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair 이름"
  type        = string
  default     = ""
}

variable "web_security_group_ids" {
  description = "Web 인스턴스에 연결할 보안 그룹 ID list"
  type        = list(string)
}

variable "user_data_script" {
  description = "인스턴스 시작 시 실행할 사용자 스크립트"
  type        = string
  default     = ""
}

# EBS Variables
variable "root_volume_size" {
  description = "루트 볼륨 크기"
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

# Auto Scaling Group Variables
variable "private_subnet_ids" {
  description = "ASG에 연결할 프라이빗 서브넷 ID list"
  type        = list(string)
}

variable "availability_zones" {
  description = "ASG가 배포될 가용 영역 list"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ALB에 연결할 타겟 그룹 ARN list"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "Health check 타입"
  type        = string
  default     = "ALB"
}

variable "health_check_grace_period" {
  description = "Health check 대기 시간"
  type        = number
  default     = 300
}

variable "min_size" {
  description = "최소 인스턴스 수"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "최대 인스턴스 수"
  type        = number
  default     = 10
}

variable "desired_capacity" {
  description = "원하는 인스턴스 수"
  type        = number
  default     = 2
}

variable "instance_warmup" {
  description = "인스턴스 워밍업 시간"
  type        = number
  default     = 300
}

# Auto Scaling Policies
variable "enable_auto_scaling" {
  description = "Auto Scaling 활성화 여부"
  type        = bool
  default     = true
}

variable "enable_step_scaling" {
  description = "Step Scaling 활성화 여부"
  type        = bool
  default     = false
}

# Target Tracking
variable "target_cpu_utilization" {
  description = "Target CPU utilization"
  type        = number
  default     = 70
}

# Step Scaling Variables
variable "scale_out_adjustment" {
  description = "Scale Out 시 추가할 인스턴스 수"
  type        = number
  default     = 1
}

variable "scale_in_adjustment" {
  description = "Scale In 시 제거할 인스턴스 수"
  type        = number
  default     = -1
}

variable "cpu_high_threshold" {
  description = "CPU 사용률이 높을 때의 임계값"
  type        = number
  default     = 80
}

variable "cpu_low_threshold" {
  description = "CPU 사용률이 낮을 때의 임계값"
  type        = number
  default     = 20
}

variable "scale_up_period" {
  description = "CPU 사용률이 높을 때의 알람 주기"
  type        = number
  default     = 300
}

variable "scale_down_period" {
  description = "CPU 사용률이 낮을 때의 알람 주기"
  type        = number
  default     = 300
}

variable "scale_up_evaluation_periods" {
  description = "CPU 사용률이 높을 때의 알람 주기"
  type        = number
  default     = 2
}

variable "scale_down_evaluation_periods" {
  description = "CPU 사용률이 낮을 때의 알람 주기"
  type        = number
  default     = 2
}

variable "tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
