provider "aws" {
  #region = "us-west-2"
  region = "us-east-1"
}

resource "aws_instance" "web" {
  #ami           = "ami-005bdb005fb00e791"
  ami           = "ami-0a313d6098716f372"

  instance_type = "t2.micro"
  #key_name = "demokp"
  key_name = "demovir"

  #vpc_security_group_ids = ["sg-0b57c61023d544d66"]
  vpc_security_group_ids = ["${aws_security_group.demo.id}"]

  tags = {
    Name = "HelloWorld"
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

