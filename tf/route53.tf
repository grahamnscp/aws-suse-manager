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

# alias for suse manager ui
resource "aws_route53_record" "smgr-alias" {
  zone_id = "${var.route53_zone_id}"
  name = "smgr.${var.route53_subdomain}.${var.route53_domain}"
  type = "CNAME"
  ttl = "60"
  records = [aws_route53_record.smgr.0.name]
}

# Client instances
resource "aws_route53_record" "client" {
  zone_id = "${var.route53_zone_id}"
  count = "${var.node_count_client}"
  name = "${var.prefix}-client${count.index + 1}.${var.route53_subdomain}.${var.route53_domain}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_eip.client-eip.*.public_ip, count.index)}"]
}

