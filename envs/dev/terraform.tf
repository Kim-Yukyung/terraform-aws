terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = try(var.aws_profile, null)
}
