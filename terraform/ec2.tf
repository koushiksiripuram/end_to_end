resource "aws_default_vpc" "default" {

}

data "aws_ebs_volume" "ghost_data" {
  filter {
    name   = "tag:Name"
    values = ["ghost_data"]
  }
}

data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_eip" "ghost_eip" {

  public_ip = var.public_ip
}

resource "aws_eip_association" "ghost_assoc" {

  instance_id = aws_instance.ghost_server.id

  allocation_id = data.aws_eip.ghost_eip.id
}
resource "aws_instance" "ghost_server" {

  ami = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.ghost_sg.id]

  # associate_public_ip_address = true
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "ghost-server"
  }
}
resource "aws_volume_attachment" "ghost_data_attach" {
  device_name = "/dev/sdf"
  volume_id   = data.aws_ebs_volume.ghost_data.id
  instance_id = aws_instance.ghost_server.id
}
