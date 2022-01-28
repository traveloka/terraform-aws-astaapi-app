output "lb_security_group_id" {
  description = "The ID of LB security group"
  value       = aws_security_group.lbext_sg.id
}

output "app_security_group_id" {
  description = "The ID of App security group"
  value       = aws_security_group.app_sg.id
}

output "lb_tg_active_name" {
  description = "Active Target Group name of the LB"
  value       = module.alb_lbext.tg_active_name
}

output "lb_tg_standby_name" {
  description = "Standby Target Group name of the LB"
  value       = module.alb_lbext.tg_standby_name
}

output "lb_arn" {
  value = module.alb_lbext.lb_arn
}
output "lb_listener_arn" {
  value = module.alb_lbext.listener_arn
}

output "lb_arn_suffix" {
  value = module.alb_lbext.lb_arn_suffix
}

output "lb_tg_active_arn_suffix" {
  value = module.alb_lbext.tg_active_arn_suffix
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.astaapi_deployment.deployment_group_name
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}

output "ecs_role_name" {
  value = module.ecs_task_role.role_name
}