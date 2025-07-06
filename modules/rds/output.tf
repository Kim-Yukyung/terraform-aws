output "db_instance_id" {
  description = "RDS 인스턴스 ID"
  value       = aws_db_instance.rds.id
}

output "db_instance_arn" {
  description = "RDS 인스턴스 ARN"
  value       = aws_db_instance.rds.arn
}

output "db_instance_endpoint" {
  description = "RDS 인스턴스 엔드포인트"
  value       = aws_db_instance.rds.endpoint
}

output "db_instance_address" {
  description = "RDS 인스턴스 주소"
  value       = aws_db_instance.rds.address
}

output "db_instance_port" {
  description = "RDS 인스턴스 포트"
  value       = aws_db_instance.rds.port
}

output "db_instance_username" {
  description = "RDS 인스턴스 사용자명"
  value       = aws_db_instance.rds.username
  sensitive   = true
}

output "db_instance_status" {
  description = "RDS 인스턴스 상태"
  value       = aws_db_instance.rds.status
}

output "db_instance_engine" {
  description = "RDS 인스턴스 엔진"
  value       = aws_db_instance.rds.engine
}

output "db_instance_engine_version" {
  description = "RDS 인스턴스 엔진 버전"
  value       = aws_db_instance.rds.engine_version
}

output "db_instance_class" {
  description = "RDS 인스턴스 클래스"
  value       = aws_db_instance.rds.instance_class
}

output "db_instance_allocated_storage" {
  description = "RDS 인스턴스 할당된 스토리지"
  value       = aws_db_instance.rds.allocated_storage
}

output "db_instance_multi_az" {
  description = "RDS 인스턴스 다중 AZ 여부"
  value       = aws_db_instance.rds.multi_az
}
