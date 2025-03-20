# Instances:

# SUSE Manager Nodes
resource "aws_instance" "smgr" {

  instance_type = "${var.aws_instance_type_smgr}"
  ami           = "${var.aws_ami_smgr}"
  key_name      = "${var.aws_key_name}"

  root_block_device {
    volume_size = "${var.volume_size_root}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  # second disk
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "${var.volume_size_data}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  iam_instance_profile = "${aws_iam_instance_profile.suse_instance_profile.id}"

  vpc_security_group_ids = ["${aws_security_group.dc-instance-sg.id}"]
  subnet_id = "${aws_subnet.dc-subnet1.id}"

  #user_data = "${file("userdata-smgr.sh")}"
  user_data = "${file(lookup(local.smgr_ud_map, "smgr-ud${count.index}", "userdata-smgr1.sh"))}"

  count = "${var.node_count_smgr}"

  tags = {
    Name = "${var.prefix}-smgr${count.index + 1}"
  }
}

# SUSE Manager Client Instances
resource "aws_instance" "client" {

  instance_type = "${var.aws_instance_type_client}"
  ami           = "${var.aws_ami_client}"
  key_name      = "${var.aws_key_name}"

  root_block_device {
    volume_size = "${var.volume_size_root_client}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  iam_instance_profile = "${aws_iam_instance_profile.suse_instance_profile.id}"

  vpc_security_group_ids = ["${aws_security_group.dc-instance-sg.id}"]
  subnet_id = "${aws_subnet.dc-subnet1.id}"

  user_data = "${file("userdata-client.sh")}"

  count = "${var.node_count_client}"

  tags = {
    Name = "${var.prefix}-client${count.index + 1}"
  }
}
