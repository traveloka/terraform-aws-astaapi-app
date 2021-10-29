#######
# ALB #
#######
module "lb_sg_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.18.1"
  name_prefix   = "${local.lb_cluster_name}"
  resource_type = "security_group"
}

resource "aws_security_group" "lb_sg" {
  name        = "${module.lb_sg_name.name}"
  description = "internal security group for ${local.lb_cluster_name}"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name          = "${module.lb_sg_name.name}"
    Service       = "${local.service_name}"
    ProductDomain = "${local.product_domain}"
    Environment   = "${var.environment}"
    Description   = "internal security group for ${local.lb_cluster_name}"
    ManagedBy     = "terraform"
  }
}

module "int_alb" {
  source = "github.com/traveloka/terraform-aws-alb-single-listener?ref=v0.2.3"

  service_name   = "${local.service_name}"
  environment    = "${var.environment}"
  product_domain = "${local.product_domain}"
  description    = "internal application load balancer for ${local.app_cluster_name}"

  vpc_id                   = "${var.vpc_id}"
  lb_subnet_ids            = "${var.lb_subnet_ids}"
  lb_security_groups       = ["${aws_security_group.lb_sg.id}"]
  listener_certificate_arn = "${var.listener_certificate_arn}"
  lb_logs_s3_bucket_name   = "${var.lb_logs_s3_bucket_name}"
  cluster_role             = "${local.app_cluster_role}"

  tg_port                 = "${local.app_port}"
  tg_health_check         = "${merge(local.lb_tg_health_check, var.lb_tg_health_check)}"
  tg_deregistration_delay = "${local.lb_tg_deregistration_delay}"
}

resource "aws_route53_record" "lb" {
  zone_id = "${var.route53_private_zone_id}"
  name    = "${local.lb_route53_record_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name                   = "${lower(module.int_alb.lb_dns)}"
    zone_id                = "${module.int_alb.lb_zone_id}"
    evaluate_target_health = false
  }
}

####################
### IAM Policies ###
####################
module "instance_profile" {
  source       = "github.com/traveloka/terraform-aws-iam-role/modules/instance?ref=v1.0.2"
  service_name = "${local.service_name}"
  cluster_role = "${local.app_cluster_role}"

  product_domain = "${local.product_domain}"
  environment    = "${var.environment}"
}

resource "aws_iam_role_policy" "this" {
  role   = "${module.instance_profile.role_name}"
  policy = "${data.aws_iam_policy_document.app.json}"
}

resource "aws_iam_role_policy_attachment" "commonEC2" {
  role       = "${module.instance_profile.role_name}"
  policy_arn = "${var.commonEC2_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = "${module.instance_profile.role_name}"
  policy_arn = "${var.ssm_policy_arn}"
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  role   = "${module.instance_profile.role_name}"
  policy = "${data.aws_iam_policy_document.accom_competitiveness_rate_monitor_dynamodb.json}"
}

#######
# APP #
#######
module "app_sg_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.18.1"
  name_prefix   = "${local.app_cluster_name}"
  resource_type = "security_group"
}

resource "aws_security_group" "app_sg" {
  name        = "${module.app_sg_name.name}"
  description = "application security group for ${local.app_cluster_name}"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name          = "${module.app_sg_name.name}"
    Service       = "${local.service_name}"
    ProductDomain = "${local.product_domain}"
    Environment   = "${var.environment}"
    Description   = "application security group for ${local.app_cluster_name}"
    ManagedBy     = "terraform"
  }
}

module "asg" {
  source = "github.com/traveloka/terraform-aws-autoscaling?ref=v0.2.8"

  service_name   = "${local.service_name}"
  environment    = "${var.environment}"
  product_domain = "${local.product_domain}"
  description    = "autoscaling group for ${local.app_cluster_name}"
  application    = "java-8"

  security_groups           = ["${aws_security_group.app_sg.id}"]
  instance_profile_name     = "${module.instance_profile.instance_profile_name}"
  launch_template_overrides = "${var.launch_template_override}"

  image_owners                 = "${local.image_owners}"
  mixed_instances_distribution = "${var.mixed_instances_distribution}"

  image_filters = [
    {
      # See https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html for complete filter options
      name   = "name"
      values = ["tvlk/ubuntu-16/ast/java-*"]
    },
    {
      # If you want to directly specify the image ID
      name   = "image-id"
      values = ["${var.ami_id}"]
    },
  ]

  user_data = "${var.user_data}"

  asg_min_capacity         = "${var.asg_min_capacity}"
  asg_max_capacity         = "${var.asg_max_capacity}"
  asg_vpc_zone_identifier  = ["${var.asg_vpc_zone_identifier}"]
  asg_lb_target_group_arns = ["${module.int_alb.tg_arn}"]

  asg_health_check_type         = "${local.asg_health_check_type}"
  asg_wait_for_capacity_timeout = "${local.asg_wait_for_capacity_timeout}"

  asg_tags = [
    {
      key                 = "AmiId"
      value               = "${var.ami_id}"
      propagate_at_launch = true
    },
  ]
}

module "autoscaling_policy_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.18.1"

  name_prefix   = "${local.app_cluster_name}"
  resource_type = "autoscaling_policy"
}

resource "aws_autoscaling_policy" "app" {
  name                   = "${module.autoscaling_policy_name.name}"
  autoscaling_group_name = "${module.asg.asg_name}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "${local.asg_policy_cpu_target_value}"
  }
}