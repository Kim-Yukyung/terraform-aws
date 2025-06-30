output "vpc_id" {
  description = "생성된 VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

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

output "public_subnets_by_az" {
  description = "AZ별 퍼블릭 서브넷 ID 맵 (availability_zone -> subnet_id)"
  value       = { for k, v in aws_subnet.public : v.availability_zone => v.id }
}

output "private_subnets_by_az" {
  description = "AZ별 프라이빗 서브넷 ID 맵 (availability_zone -> subnet_id)"
  value       = { for k, v in aws_subnet.private : v.availability_zone => v.id }
}

output "nat_gateway_ids" {
  description = "생성된 NAT Gateway ID 목록"
  value       = [for nat in aws_nat_gateway.this : nat.id]
}

output "db_subnet_group_name" {
  description = "RDS에서 사용할 DB Subnet Group 이름"
  value       = length(aws_db_subnet_group.this) > 0 ? aws_db_subnet_group.this[0].name : null
}
