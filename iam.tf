module "ecs_task_role" {
  source  = "traveloka/iam-role/aws//modules/service"
  version = "2.0.2"

  role_identifier            = "ecs-task"
  role_description           = "Service Role for the ECS tasks"
  role_force_detach_policies = false
  product_domain             = local.product_domain
  environment                = var.environment

  aws_service = "ecs-tasks.amazonaws.com"
}

resource "aws_iam_role_policy" "ecs_execute_command" {
  role   = module.ecs_task_role.role_name
  policy = data.aws_iam_policy_document.execute_command.json
}

resource "aws_iam_role_policy" "ecs_app_policy" {
  role   = module.ecs_task_role.role_name
  policy = data.aws_iam_policy_document.app.json
}

resource "aws_iam_role_policy_attachment" "commonEC2" {
  role       = module.ecs_task_role.role_name
  policy_arn = var.commonec2_policy_arn
}