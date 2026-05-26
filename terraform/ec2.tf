resource "aws_default_vpc" "default" {

}
data "aws_eip" "ghost_eip" {

  public_ip = var.public_ip
}
resource "aws_eip_association" "ghost_assoc" {

  instance_id = aws_instance.ghost_server.id

  allocation_id = data.aws_eip.ghost_eip.id
}
resource "aws_instance" "ghost_server" {

  ami = "ami-0e35ddab05955cf57"

  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.ghost_sg.id]

  # associate_public_ip_address = true

  tags = {
    Name = "ghost-server"
  }
}