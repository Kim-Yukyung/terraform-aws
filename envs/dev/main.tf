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
