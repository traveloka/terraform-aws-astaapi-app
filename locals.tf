locals {
  service_name   = "astaapi"
  product_domain = "ast"

  lb_cluster_role = "lbint"

  lb_cluster_name = "${local.service_name}-${local.lb_cluster_role}"

  lb_route53_record_name = "${var.lb_route53_record_name == "" ? local.service_name : var.lb_route53_record_name}"

  lb_tg_health_check = {
    port = "${local.app_port}"
  }

  lb_tg_deregistration_delay = "120"

  image_owners = ["112120735838"] #tvlk-ast-dev

  app_cluster_role = "app"
  app_cluster_name = "${local.service_name}-${local.app_cluster_role}"
  app_port         = 29911

  asg_health_check_type         = "ELB"
  asg_wait_for_capacity_timeout = "7m"
  asg_policy_cpu_target_value   = 40.0

  secure_port  = 443
  http_port    = 80
}