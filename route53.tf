resource "aws_route53_record" "public" {
  zone_id = var.route53_public_zone_id
  name    = "origin-${local.lb_route53_record_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name                   = module.alb_lbext.lb_dns
    zone_id                = module.alb_lbext.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "akamai" {
  zone_id = var.route53_public_zone_id
  name    = "akamai-${local.lb_route53_record_name}.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_route53_record.public.fqdn]
}

resource "aws_route53_record" "user" {
  zone_id = var.route53_public_zone_id
  name    = "${local.lb_route53_record_name}.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [var.lbext_akamai_hostname == "" ? aws_route53_record.public.fqdn : var.lbext_akamai_hostname]
}