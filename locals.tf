locals {
  service_name   = "astaapi"
  product_domain = "ast"
  app_port       = 8080
  https_port     = 443

  lb_route53_record_name    = coalesce(var.lb_route53_record_name, local.service_name)
  ecs_container_definitions = coalesce(var.custom_container_definitions, data.template_file.container_definitions.rendered)
}