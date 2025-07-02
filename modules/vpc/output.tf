# VPC 정보
output "vpc_id" {
  description = "생성된 VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.main.cidr_block
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.main.cidr_block
}

# IGW
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.gw.id
}

# 서브넷 ID 목록

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "database_subnet_ids" {
  description = "DB 서브넷 ID 목록"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

# AZ 별 서브넷 매핑

output "public_subnets_by_az" {
  description = "AZ 별 퍼블릭 서브넷 ID 맵 (availability_zone -> subnet_id)"
  value       = { for k, v in aws_subnet.public : v.availability_zone => v.id }
}

output "private_subnets_by_az" {
  description = "AZ 별 프라이빗 서브넷 ID 맵 (availability_zone -> subnet_id)"
  value       = { for k, v in aws_subnet.private : v.availability_zone => v.id }
}

# NAT Gateway
output "nat_gateway_ids" {
  description = "생성된 NAT Gateway ID 목록"
  value       = [for nat in aws_nat_gateway.default : nat.id]
}

# RDS Subnet Group
output "db_subnet_group_name" {
  description = "RDS에서 사용할 DB Subnet Group 이름"
  value       = length(aws_db_subnet_group.database) > 0 ? aws_db_subnet_group.database[0].name : null
}

# 가용 영역 목록
output "availability_zones" {
  description = "사용된 가용 영역 목록"
  value = distinct(concat(
    [for subnet in aws_subnet.public : subnet.availability_zone],
    [for subnet in aws_subnet.private : subnet.availability_zone],
    [for subnet in aws_subnet.database : subnet.availability_zone]
  ))
}
