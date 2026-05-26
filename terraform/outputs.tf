output "ec2_public_ip" {

  value = aws_instance.ghost_server.public_ip
}

output "ec2_public_dns" {

  value = aws_instance.ghost_server.public_dns
}
output "elastic_ip" {
  value = data.aws_eip.ghost_eip.public_ip
}