resource "aws_instance" "demo" {
  ami           = "${data.aws_ami.myami.id}"
  count         = "${var.instancias}"

  instance_type = "${var.type}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.demo.id}"]

  tags = {
    Name = "${var.env}_${var.name}_${count.index}"
  }
}

resource "aws_security_group" "demo" {
  name        = "${var.env}_sg_${var.name}"
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
