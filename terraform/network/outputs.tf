output "fnf-lb-security-group_id" {
  value = aws_security_group.fnf-lb-security-group.id
}

output "fnf-subnet-private1-us-east-1a_id" {
  value = aws_subnet.fnf-subnet-private1-us-east-1a.id
}

output "fnf-subnet-private2-us-east-1b_id" {
  value = aws_subnet.fnf-subnet-private2-us-east-1b.id
}

output "fnf-alb-http_arn" {
  value = aws_lb_listener.fnf-alb-http.arn
}

output "fnf-cluster-security-group_id" {
  value = aws_security_group.fnf-cluster-security-group.id
}

output "fnf-lb-target-group_arn" {
  value = aws_lb_target_group.fnf-lb-target-group.arn
}

output "fnf-alb" {
  value = aws_alb.fnf-alb
}

output "fnf-database-security-group_id" {
  value = aws_security_group.fnf-database-security-group.id
}