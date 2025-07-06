resource "aws_db_instance" "rds" {
  identifier = "${var.prefix}-rds"

  # 엔진 설정
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  username = var.db_username
  password = var.db_password

  # 네트워크 설정
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = var.publicly_accessible

  # 스토리지 설정
  allocated_storage     = var.allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  max_allocated_storage = var.max_allocated_storage

  multi_az = var.multi_az

  # 삭제 설정
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  # 모니터링 설정
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn

  performance_insights_enabled = var.performance_insights_enabled

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-rds"
    }
  )
}
