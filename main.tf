provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "myami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-hvm-2018.03.0.20181129-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "demo" {
  #ami           = "${var.ami_id}"
  ami           = "${data.aws_ami.myami.id}"

  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.demo.id}"]

  tags = {
    Name = "demo"
  }
}

output "demo_ip" {
  value = "${aws_instance.demo.public_ip}"
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
    #cidr_blocks     = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.myelb.id}"]
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

resource "aws_elb" "demo" {
  name               = "demo"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
  source_security_group = "${aws_security_group.myelb.id}"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.demo.id}", "${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_security_group" "myelb" {
  name        = "sg_myelb"
  description = "Allow http inbound traffic"

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
