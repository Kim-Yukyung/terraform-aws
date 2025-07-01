# ALB Security Group
resource "aws_security_group" "alb" {
  name_prefix = "${var.prefix}-alb-"
  vpc_id      = var.vpc_id
  description = "ALB security group"

  tags = merge(var.tags, {
    Name = "${var.prefix}-alb-sg"
    Type = "ALB"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  for_each          = toset(var.allowed_alb_cidr_blocks)
  security_group_id = aws_security_group.alb.id

  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  for_each          = toset(var.allowed_alb_cidr_blocks)
  security_group_id = aws_security_group.alb.id

  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # 모든 프로토콜 허용
}

# Bastion Host Security Group
resource "aws_security_group" "bastion" {
  name_prefix = "${var.prefix}-bastion-"
  vpc_id      = var.vpc_id
  description = "Bastion Host security group"

  tags = merge(var.tags, {
    Name = "${var.prefix}-bastion-sg"
    Type = "Bastion"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  for_each          = toset(var.allowed_ssh_cidr_blocks)
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "bastion_all" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Web Server Security Group
resource "aws_security_group" "web" {
  name_prefix = "${var.prefix}-web-"
  vpc_id      = var.vpc_id
  description = "Web Server security group"

  tags = merge(var.tags, {
    Name = "${var.prefix}-web-sg"
    Type = "WebServer"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_http" {
  security_group_id            = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.alb.id

  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "Allow HTTP traffic from ALB"
}

resource "aws_vpc_security_group_ingress_rule" "web_https" {
  security_group_id            = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.alb.id

  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "Allow HTTPS traffic from ALB"
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh" {
  security_group_id            = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.bastion.id
  
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "Allow SSH traffic from Bastion"
}

resource "aws_vpc_security_group_egress_rule" "web_all" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

# Database Security Group
resource "aws_security_group" "database" {
  name_prefix = "${var.prefix}-db-"
  vpc_id      = var.vpc_id
  description = "RDS database security group"

  tags = merge(var.tags, {
    Name = "${var.prefix}-database-sg"
    Type = "Database"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_web" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.web.id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allow MySQL (3306) traffic from web server"
}

resource "aws_vpc_security_group_ingress_rule" "db_from_bastion" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.bastion.id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allow MySQL (3306) traffic from Bastion"
}
