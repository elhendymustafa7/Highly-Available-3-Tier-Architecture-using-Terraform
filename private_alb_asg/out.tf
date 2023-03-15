output "webserver_security_group_id" {
  value = aws_security_group.webserver-security-group.id
}
output "ssh_security_group_id" {
  value = aws_security_group.ssh-security-group.id
}
output "alb_security_group_id" {
  value = aws_security_group.alb-security-group.id
}