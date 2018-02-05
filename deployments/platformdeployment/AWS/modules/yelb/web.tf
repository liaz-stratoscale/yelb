data "template_file" "uiinit"{
  template = "${file("./modules/yelb/uiinit.sh")}"

  vars {
    yelb_appserver = "${aws_instance.yelb-app.private_ip}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["*yelb-image*"]
  }
}

resource "aws_instance" "yelb-web" {
  ami = "${data.aws_ami.ubuntu.image_id}"
  security_groups = ["${aws_security_group.web.id}"]
  instance_type = "c4.large"
  subnet_id = "${aws_subnet.app_subnet1.id}"
  key_name = "demoapp"

  tags {
    Name = "yelb-web${count.index}"
  }
  user_data = "${data.template_file.uiinit.rendered}"
  count=2
}

output "web-ips" {
  value = "${aws_instance.yelb-web.*.private_ip}"
}

output "web-ids" {
  value = "${join(",", aws_instance.yelb-web.*.id)}"
}