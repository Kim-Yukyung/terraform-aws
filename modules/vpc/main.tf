resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # EC2 인스턴스에 퍼블릭 DNS 호스트네임을 부여할지 여부
  enable_dns_hostnames = true

  # VPC에서 DNS Resolution을 활성화할지 여부
  enable_dns_support = true

  tags = merge(var.tags, {
    Name = "${var.prefix}-vpc"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.prefix}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # 이 서브넷에 생성되는 EC2 인스턴스에 퍼블릭 IP 자동 할당
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.prefix}-public-${each.key}"
    Type = "Public"
  })
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${var.prefix}-private-${each.key}"
    Type = "Private"
  })
}

resource "aws_subnet" "database" {
  for_each = var.database_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${var.prefix}-database-${each.key}"
    Type = "Database"
  })
}

resource "aws_eip" "nat" {
  # NAT Gateway를 활성화한 경우에만 퍼블릭 서브넷 개수만큼 EIP를 생성
  for_each = var.enable_nat_gateway ? var.public_subnets : {}

  domain = "vpc"

  depends_on = [aws_internet_gateway.gw]

  tags = merge(var.tags, {
    Name = "${var.prefix}-eip-${each.key}"
  })
}

resource "aws_nat_gateway" "default" {
  for_each = var.enable_nat_gateway ? var.public_subnets : {}

  # 연결할 Elastic IP의 ID
  allocation_id = aws_eip.nat[each.key].id

  # NAT Gateway가 배치될 퍼블릭 서브넷의 ID
  subnet_id = aws_subnet.public[each.key].id

  tags = merge(var.tags, {
    Name = "${var.prefix}-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.gw]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.prefix}-public-rt"
  })
}

# Public Route to Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables (AZ별로 하나씩 생성)
resource "aws_route_table" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.prefix}-private-rt-${each.key}"
  })
}

# Private Route to NAT Gateway
resource "aws_route" "private_nat_access" {
  for_each               = var.enable_nat_gateway ? var.private_subnets : {}
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[each.key].id
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

# Database Route Tables
resource "aws_route_table" "database" {
  for_each = var.database_subnets

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.prefix}-database-rt-${each.key}"
  })
}

# Database Route Table Association
resource "aws_route_table_association" "database" {
  for_each       = aws_subnet.database
  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[each.key].id
}

# RDS에서 사용할 DB Subnet Group 생성
resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnets) > 0 ? 1 : 0

  name       = "${var.prefix}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.database : subnet.id]

  tags = merge(var.tags, {
    Name = "${var.prefix}-db-subnet-group"
  })
}
