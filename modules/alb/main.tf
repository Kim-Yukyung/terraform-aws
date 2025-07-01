resource "aws_lb" "alb" {
  name               = "${var.prefix}-alb"
  internal           = false                  # 외부 인터넷에서 접근 가능
  load_balancer_type = "application"          # Application Load Balancer로 설정
  security_groups    = var.security_group_ids # ALB에 연결할 보안 그룹 ID 목록
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = "${var.prefix}-alb"
    Type = "ALB"
  })
}

resource "aws_lb_target_group" "tg" {
  name_prefix = "${var.prefix}-"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.prefix}-tg"
    Type = "TargetGroup"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-http-listener"
    Type = "listener"
  })
}
