# Route53 for instances

# SUSE Manager entries
resource "aws_route53_record" "smgr" {
  zone_id = "${var.route53_zone_id}"
  count = "${var.node_count_smgr}"
  name = "${var.prefix}-smgr${count.index + 1}.${var.route53_subdomain}.${var.route53_domain}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_eip.smgr-eip.*.public_ip, count.index)}"]
}

# alias for suse manager ui (for multiple nodes need to add different name in userdata)
#   mgradm -c /root/mgradm.yaml install podman smgrX.##SUSE_MANAGER_5_DOMAIN##
resource "aws_route53_record" "smgr-alias" {
  zone_id = "${var.route53_zone_id}"
  count = "${var.node_count_smgr}"
  name = "smgr${count.index + 1}.${var.route53_subdomain}.${var.route53_domain}"
  type = "CNAME"
  ttl = "60"
  records = ["${element(aws_route53_record.smgr.*.name, count.index)}"]
}

# Client instances
resource "aws_route53_record" "client" {
  zone_id = "${var.route53_zone_id}"
  count = "${var.node_count_client}"
  name = "${var.prefix}-sles${count.index + 1}.${var.route53_subdomain}.${var.route53_domain}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_eip.client-eip.*.public_ip, count.index)}"]
}
resource "aws_route53_record" "client2" {
  zone_id = "${var.route53_zone_id}"
  count = "${var.node_count_client2}"
  name = "${var.prefix}-slm${count.index + 1}.${var.route53_subdomain}.${var.route53_domain}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_eip.client2-eip.*.public_ip, count.index)}"]
}

