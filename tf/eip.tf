# elastic ips

# Associate Elastic IPs to Instances
resource "aws_eip" "smgr-eip" {

  count = "${var.node_count_smgr}"
  instance = "${element(aws_instance.smgr.*.id, count.index)}"

  tags = {
    Name = "${var.prefix}_smgr${count.index + 1}"
  }

  depends_on = [aws_instance.smgr]
}

resource "aws_eip" "client-eip" {

  count = "${var.node_count_client}"
  instance = "${element(aws_instance.client.*.id, count.index)}"

  tags = {
    Name = "${var.prefix}_client${count.index + 1}"
  }

  depends_on = [aws_instance.client]
}
