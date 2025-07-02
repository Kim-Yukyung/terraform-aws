# Launch Template Outputs
output "launch_template_id" {
  description = "launch template id"
  value       = aws_launch_template.web.id
}

output "launch_template_arn" {
  description = "launch template arn"
  value       = aws_launch_template.web.arn
}

# AMI Information
output "ami_id" {
  description = "사용된 AMI ID"
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.image.id
}

output "ami_name" {
  description = "사용된 AMI 이름"
  value       = data.aws_ami.image.name
}

# Auto Scaling Group Outputs
output "autoscaling_group_id" {
  description = "Auto Scaling Group ID"
  value       = aws_autoscaling_group.web.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group arn"
  value       = aws_autoscaling_group.web.arn
}

output "autoscaling_group_min_size" {
  description = "Auto Scaling Group 최소 인스턴스 수"
  value       = aws_autoscaling_group.web.min_size
}

output "autoscaling_group_max_size" {
  description = "Auto Scaling Group 최대 인스턴스 수"
  value       = aws_autoscaling_group.web.max_size
}

output "autoscaling_group_desired_capacity" {
  description = "Auto Scaling Group 원하는 인스턴스 수"
  value       = aws_autoscaling_group.web.desired_capacity
}

# Auto Scaling Policy Outputs
output "scale_out_policy_arn" {
  description = "Scale Out policy arn"
  value       = var.enable_step_scaling ? aws_autoscaling_policy.scale_out[0].arn : ""
}

output "scale_in_policy_arn" {
  description = "Scale In policy arn"
  value       = var.enable_step_scaling ? aws_autoscaling_policy.scale_in[0].arn : ""
}

# CloudWatch Alarm Outputs
output "cpu_high_alarm_arn" {
  description = "CPU 사용률이 높을 때의 알람 arn"
  value       = var.enable_step_scaling ? aws_cloudwatch_metric_alarm.cpu_high[0].arn : ""
}

output "cpu_low_alarm_arn" {
  description = "CPU 사용률이 낮을 때의 알람 arn"
  value       = var.enable_step_scaling ? aws_cloudwatch_metric_alarm.cpu_low[0].arn : ""
}
