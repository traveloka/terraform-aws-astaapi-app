module "aws-resource-naming_lbext" {
  source        = "git::https://github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.19.1"
  name_prefix   = "${local.service_name}-ecs-lbextF"
  resource_type = "lb"
}

module "aws-resource-naming_tgext" {
  source        = "git::https://github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.19.1"
  name_prefix   = "${local.service_name}-ecs-app"
  resource_type = "lb_target_group"
}

module "alb_lbext" {
  source = "github.com/traveloka/terraform-aws-alb-single-listener.git?ref=ecs_codedeploy"

  service_name              = local.service_name
  cluster_role              = "app"
  environment               = var.environment
  product_domain            = local.product_domain
  description               = "${local.service_name}-lbext for ${var.environment}"

  lb_name                   = module.aws-resource-naming_lbext.name
  tg_name                   = module.aws-resource-naming_tgext.name
  tg_target_type            = "ip"
  lb_logs_s3_bucket_name    = var.lb_logs_s3_bucket_name
  lb_subnet_ids             = var.lb_subnet_ids
  tg_port                   = local.app_port
  lb_internal               = false
  listener_certificate_arn  = var.external_listener_certificate_arn
  vpc_id                    = var.vpc_id
  lb_tags                   = var.additional_tags

  lb_security_groups = flatten([aws_security_group.lbext_sg.id, var.additional_lb_security_group_ids])

  tg_health_check = {
    "interval"            = 10
    "path"                = "/healthcheck"
    "healthy_threshold"   = 2
    "unhealthy_threshold" = 2
    "timeout"             = 5
    "protocol"            = "HTTP"
    "matcher"             = "200"
  }
}