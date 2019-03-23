output "public_ips" {
  value = "${aws_instance.demo.*.public_ip}"
}
output "ids" {
  value = "${aws_instance.demo.*.id}"
}
output "sg_id" {
  value = "${aws_security_group.demo.id}"
}
