variable db_class {}
variable db_version {}

resource "aws_db_subnet_group" "db_subnet" {
  subnet_ids = ["${aws_subnet.app_subnet1.id}","${aws_subnet.app_subnet2.id}"]
}

resource "aws_db_instance" "yelbdb" {
  identifier = "yelb-db"
  instance_class = "${var.db_class}"
  vpc_security_group_ids = ["${aws_security_group.app.id}"]
  allocated_storage = 10
  engine = "postgres"
  name = "yelbdatabase"
  password = "yelbdbuser"
  username = "yelbdbuser"
  engine_version = "${var.db_version}"
  skip_final_snapshot = true
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet.name}"
  lifecycle {
    ignore_changes = ["engine", "auto_minor_version_upgrade", "vpc_security_group_ids"]
  }
}

output "db_endpoint" {
  value = "${aws_db_instance.yelbdb.address}"
}
