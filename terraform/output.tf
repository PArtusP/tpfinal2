output "ip_address" {
  value = aws_instance.instance_jenkins_server_artus.*.public_ip
}
