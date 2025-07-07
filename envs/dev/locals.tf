# 공통 태그 정의
locals {
  common_tags = {
    Environment = "dev"
    Project     = "aws"
    ManagedBy   = "terraform"
  }
}

locals {
  prefix = "dev"
}
