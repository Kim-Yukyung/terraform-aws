output "alb_arn" {
  description = "로드 밸런서 ARN"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "로드 밸런서 DNS 이름"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "로드 밸런서 Canonical Hosted Zone ID"
  value       = aws_lb.alb.zone_id
}

output "target_group_arns" {
  description = "타겟 그룹 ARN 목록"
  value       = [aws_lb_target_group.tg.arn]
}

output "target_group_name" {
  description = "타겟 그룹 이름"
  value       = aws_lb_target_group.tg.name
}

output "http_listener_arn" {
  description = "HTTP 리스너 ARN"
  value       = aws_lb_listener.http.arn
}
