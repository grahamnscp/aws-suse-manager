# Output Values:

# Domain
output "domainname" {
  value = "${var.route53_subdomain}.${var.route53_domain}"
}

# Instances - suse manager
output "smgr-instance-private-ips" {
  value = ["${aws_instance.smgr.*.private_ip}"]
}
output "smgr-instance-public-ips" {
  value = ["${aws_eip.smgr-eip.*.public_ip}"]
}
output "smgr-instance-names" {
  value = ["${aws_route53_record.smgr.*.name}"]
}

# Instances - suse manager clients
output "client-instance-private-ips" {
  value = ["${aws_instance.client.*.private_ip}"]
}
output "client-instance-public-ips" {
  value = ["${aws_eip.client-eip.*.public_ip}"]
}
output "client-instance-names" {
  value = ["${aws_route53_record.client.*.name}"]
}

