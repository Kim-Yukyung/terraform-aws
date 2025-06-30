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
