provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "demo" {
  ami           = "${var.ami_id}"

  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.demo.id}"]

  tags = {
    Name = "demo"
  }
}

resource "aws_instance" "web" {
  ami           = "${var.ami_id}"

  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.demo.id}"]

  tags = {
    Name = "web"
  }
}

resource "aws_security_group" "demo" {
  name        = "sg_hello"
  description = "Allow http inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

variable "region" {
  description = "Region de aws"
  default = "us-west-2"
}

variable "ami_id" {
  default = "ami-005bdb005fb00e791"
}

variable "key_name" {
  default = "demokp"
}
