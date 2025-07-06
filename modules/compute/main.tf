# Launch Template
resource "aws_launch_template" "web" {
  name_prefix = "${var.prefix}-web-"

  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.image.id # 최신 Amazon Linux2 AMI 사용
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? var.key_name : null

  # 연결할 보안 그룹 ID list
  vpc_security_group_ids = var.web_security_group_ids

  # 인스턴스 시작 시 실행할 사용자 스크립트
  user_data = base64encode(var.user_data_script)

  # EBS 루트 볼륨 설정 
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      encrypted             = var.encrypt_root_volume
      delete_on_termination = true # 인스턴스 종료 시 EBS 삭제
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  # 인스턴스 태그
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = "${var.prefix}-web-instance"
      Type = "WebServer"
    })
  }

  # EBS 볼륨 태그
  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, {
      Name = "${var.prefix}-web-volume"
      Type = "WebServer"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-web-lt"
    Type = "Launch Template"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name = "${var.prefix}-web-asg"

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = var.target_group_arns

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = var.instance_warmup
    }
    triggers = ["tag"]
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-web-asg"
    propagate_at_launch = false
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "target_tracking_cpu" {
  count = var.enable_auto_scaling ? 1 : 0

  name                      = "${var.prefix}-target-tracking-cpu"
  autoscaling_group_name    = aws_autoscaling_group.web.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = var.instance_warmup

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.target_cpu_utilization
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count = var.enable_step_scaling ? 1 : 0

  name                      = "${var.prefix}-scale-out"
  autoscaling_group_name    = aws_autoscaling_group.web.name
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = var.instance_warmup

  step_adjustment {
    scaling_adjustment          = var.scale_out_adjustment
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
  }

  step_adjustment {
    scaling_adjustment          = var.scale_out_adjustment * 2
    metric_interval_lower_bound = 10
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  count = var.enable_step_scaling ? 1 : 0

  name                      = "${var.prefix}-scale-in"
  autoscaling_group_name    = aws_autoscaling_group.web.name
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = var.instance_warmup

  step_adjustment {
    scaling_adjustment          = var.scale_in_adjustment
    metric_interval_upper_bound = 0
  }
}

# CloudWatch Alarms for Step Scaling
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = var.enable_step_scaling ? 1 : 0

  alarm_name          = "${var.prefix}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.scale_up_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.scale_up_period
  statistic           = "Average"
  threshold           = var.cpu_high_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization for scale out"
  alarm_actions       = [aws_autoscaling_policy.scale_out[0].arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-cpu-high"
    Type = "alarm"
  })
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = var.enable_step_scaling ? 1 : 0

  alarm_name          = "${var.prefix}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.scale_down_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.scale_down_period
  statistic           = "Average"
  threshold           = var.cpu_low_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization for scale in"
  alarm_actions       = [aws_autoscaling_policy.scale_in[0].arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-cpu-low"
    Type = "alarm"
  })
}
