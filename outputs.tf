output "asg_name" {
  description = "The name of Auto Scaling Group"
  value       = "${module.asg.asg_name}"
}

output "launch_template_name" {
  description = "The name of the launch template used by the auto scaling group"
  value       = "${module.asg.launch_template_name}"
}

output "lb_security_group_id" {
  description = "The ID of LB security group"
  value       = "${aws_security_group.lb_sg.id}"
}

output "lb_fqdn" {
  description = "The FQDN pointing to the LB"
  value       = "${aws_route53_record.lb.fqdn}"
}

output "lbint_target_group_arn" {
  value       = "${module.int_alb.tg_arn}"
  description = "ARN of internal load balancer"
}

output "lb_target_group_name" {
  description = "The lbint target group name for the application"
  value       = "${module.int_alb.tg_name}"
}

output "app_instance_profile_arn" {
  description = "The ARN of application instance profile"
  value       = "${module.instance_profile.instance_profile_arn}"
}

output "app_role_name" {
  description = "The ARN of application role"
  value       = "${module.instance_profile.role_name}"
}

output "app_role_arn" {
  description = "The Role ARN of application instance profile"
  value       = "${module.instance_profile.role_arn}"
}

output "app_security_group_id" {
  description = "The ID of application security group"
  value       = "${aws_security_group.app_sg.id}"
}
