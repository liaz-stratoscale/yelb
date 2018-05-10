resource "aws_alb" "alb" {
  subnets = ["${aws_subnet.app_subnet1.id}","${aws_subnet.app_subnet2.id}"]
  internal = false
  security_groups = ["${aws_security_group.web.id}"]
  depends_on = ["aws_instance.yelb-web", "aws_route_table_association.external_route_associasion1", "aws_route_table_association.external_route_associasion2"]

  #workaround
  lifecycle {
    ignore_changes = ["load_balancer_type"]
  }
}

resource "aws_alb_target_group" "targ" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.app_vpc.id}"

  #workaround
  lifecycle {
    ignore_changes = ["port", "target_type", "vpc_id"]
  }
}

resource "aws_alb_target_group_attachment" "attach_web" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id = "${element(aws_instance.yelb-web.*.id, count.index)}"
  port = 80
  count = 2
}

resource "aws_alb_listener" "list" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.targ.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 8080
  depends_on = ["aws_instance.yelb-web"]
}