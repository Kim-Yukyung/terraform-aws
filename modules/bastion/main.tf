# Bastion Host EC2 Instance
resource "aws_instance" "bastion" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? var.key_name : null

  # 퍼블릭 서브넷에 배치
  subnet_id = var.public_subnet_id

  # 보안 그룹 연결
  vpc_security_group_ids = var.security_group_ids

  # 퍼블릭 IP 자동 할당
  associate_public_ip_address = true

  # 사용자 데이터 스크립트
  user_data = var.user_data_script

  # 루트 볼륨 설정
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.encrypt_root_volume
    delete_on_termination = true
  }

  # 메타데이터 옵션
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring = var.enable_detailed_monitoring

  tags = merge(var.tags, {
    Name = "${var.prefix}-bastion"
    Type = "Bastion"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP
resource "aws_eip" "bastion" {
  count = var.create_eip ? 1 : 0

  domain   = "vpc"
  instance = aws_instance.bastion.id

  tags = merge(var.tags, {
    Name = "${var.prefix}-bastion-eip"
    Type = "Bastion"
  })
}
