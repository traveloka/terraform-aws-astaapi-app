module "ecs_service" {
  source                 = "github.com/traveloka/terraform-aws-ecs-fargate-service.git?ref=codedeploy"
  service_name           = local.service_name
  cluster_role           = "app"
  application            = "java"
  product_domain         = local.product_domain
  environment            = var.environment
  enable_execute_command = true
  ecs_cluster_arn        = var.ecs_cluster_name
  service_tags           = var.additional_ecs_service_tags

  capacity = var.ecs_initial_capacity

  health_check_grace_period_seconds = var.ecs_healthcheck_grace_period
  main_container_name               = "app"
  main_container_port               = local.app_port

  task_role_arn = module.ecs_task_role.role_arn

  execution_role_arn = var.fargate_execution_role_arn

  cpu                   = var.ecs_cpu
  memory                = var.ecs_memory
  container_definitions = local.ecs_container_definitions

  target_group_arn = module.lbext_ecs.tg_active_arn

  subnet_ids = var.ecs_subnet_ids

  security_group_ids = [aws_security_group.app_sg.id]
}