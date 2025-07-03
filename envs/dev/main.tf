module "vpc" {
  source = "../../modules/vpc"

  prefix   = "dev"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = {
    az1 = { cidr = "10.0.1.0/24", az = "ap-northeast-2a" }
    az2 = { cidr = "10.0.2.0/24", az = "ap-northeast-2c" }
  }

  private_subnets = {
    az1 = { cidr = "10.0.101.0/24", az = "ap-northeast-2a" }
    az2 = { cidr = "10.0.102.0/24", az = "ap-northeast-2c" }
  }

  database_subnets = {
    az1 = { cidr = "10.0.201.0/24", az = "ap-northeast-2a" }
    az2 = { cidr = "10.0.202.0/24", az = "ap-northeast-2c" }
  }

  enable_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "aws"
    ManagedBy   = "terraform"
  }
}

module "security_groups" {
  source = "../../modules/security-groups"

  prefix = "dev"

  vpc_id = module.vpc.vpc_id

  allowed_alb_cidr_blocks = ["0.0.0.0/0"]
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "dev"
    Project     = "aws"
    ManagedBy   = "terraform"
  }
}

module "alb" {
  source = "../../modules/alb"

  prefix = "dev"

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security_groups.alb_security_group_id]

  enable_deletion_protection = false

  target_group_port     = 8080
  target_group_protocol = "HTTP"

  tags = {
    Environment = "dev"
    Project     = "aws"
    ManagedBy   = "terraform"
  }
}

module "compute" {
  source = "../../modules/compute"

  prefix = "dev"

  private_subnet_ids     = module.vpc.private_subnet_ids
  availability_zones     = module.vpc.availability_zones
  web_security_group_ids = [module.security_groups.web_security_group_id]

  # ALB 연결 
  target_group_arns = module.alb.target_group_arns

  # 인스턴스 설정
  instance_type    = "t3.micro"
  user_data_script = file("${path.module}/scripts/web_server_setup.sh")

  # 볼륨 설정
  root_volume_size    = 30
  root_volume_type    = "gp3"
  encrypt_root_volume = true

  # Auto Scaling 설정
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  # 스케일링 정책
  enable_auto_scaling    = true
  enable_step_scaling    = false
  target_cpu_utilization = 70

  # 모니터링
  enable_detailed_monitoring = true

  tags = {
    Environment = "dev"
    Project     = "aws"
    ManagedBy   = "terraform"
  }
}

module "bastion" {
  source = "../../modules/bastion"

  prefix = "dev"

  # 네트워킹
  public_subnet_id   = module.vpc.public_subnet_ids[0] # 첫 번째 퍼블릭 서브넷 사용
  security_group_ids = [module.security_groups.bastion_security_group_id]

  # 인스턴스 설정
  instance_type    = "t3.micro"
  user_data_script = file("${path.module}/scripts/bastion_setup.sh")

  # 볼륨 설정
  root_volume_size    = 20
  root_volume_type    = "gp3"
  encrypt_root_volume = true

  # Elastic IP
  create_eip = true

  # 모니터링
  enable_detailed_monitoring = false

  # 공통 태그
  tags = {
    Environment = "dev"
    Project     = "aws"
    ManagedBy   = "terraform"
  }
}
