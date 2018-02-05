data "template_file" "appinit"{
  template = "${file("./modules/yelb/appinit.sh")}"

  vars {
    db_endpoint = "${aws_db_instance.yelbdb.address}"
  }
}

resource "aws_instance" "yelb-app" {
  ami = "${data.aws_ami.ubuntu.image_id}"
  subnet_id = "${aws_subnet.app_subnet1.id}"
  security_groups = ["${aws_security_group.app.id}"]
  instance_type = "c4.large"
  key_name = "demoapp"

  tags {
    Name="yelb-app"
  }
  user_data = "${data.template_file.appinit.rendered}"
}