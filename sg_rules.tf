resource "aws_security_group_rule" "allow_egress_from_astaapi_lb_to_astaapi_app" {
  type      = "egress"
  from_port = "${local.app_port}"
  to_port   = "${local.app_port}"
  protocol  = "TCP"

  source_security_group_id = "${aws_security_group.app_sg.id}"
  security_group_id        = "${aws_security_group.lb_sg.id}"

  description = "egress from astaapi-lb to astaapi-app"
}

resource "aws_security_group_rule" "allow_ingress_from_astaapi_lb_to_astaapi_app" {
  type      = "ingress"
  from_port = "${local.app_port}"
  to_port   = "${local.app_port}"
  protocol  = "TCP"

  source_security_group_id = "${aws_security_group.lb_sg.id}"
  security_group_id        = "${aws_security_group.app_sg.id}"

  description = "ingress from astaapi-lb to astaapi-app"
}

resource "aws_security_group_rule" "allow_egress_from_astaapi_app_to_all_443" {
  type      = "egress"
  from_port = "${local.secure_port}"
  to_port   = "${local.secure_port}"
  protocol  = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.app_sg.id}"

  description = "egress from astaapi-app to all/443"
}

resource "aws_security_group_rule" "allow_egress_from_astaapi_app_to_all_80" {
  type      = "egress"
  from_port = "${local.http_port}"
  to_port   = "${local.http_port}"
  protocol  = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.app_sg.id}"

  description = "egress from astaapi-app to all/80"
}