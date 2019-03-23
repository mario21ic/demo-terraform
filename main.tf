module "ec2" {
  source     = "./modules/ec2/"
  #instancias = 2
  region     = "${var.region}"
  name       = "demo"
  env        = "${terraform.workspace}"
  ami_name   = "mynginx"
  key_name   = "demokp"
  type       = "t2.micro"
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
  name        = "${terraform.workspace}_sg_myelb"
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
