variable "aws_region" {

  default = "us-east-1"
}

variable "instance_type" {

  default = "m7i-flex.large"
}

variable "ami_id" {

  default = "ami-091138d0f0d41ff90"
}
variable "key_name" {

  default = "master"
}
variable "public_ip" {

  type = string
}
variable "mail_endpoint" {

  type = string
}