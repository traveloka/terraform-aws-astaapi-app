resource "aws_codedeploy_deployment_group" "astaapi_deployment" {
  app_name               = var.codedeploy_app_name
  deployment_config_name = var.ecs_deployment_config
  deployment_group_name  = "${local.service_name}-ecs"
  service_role_arn       = var.codedeploy_service_role_arn

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = module.ecs_service.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          module.alb_lbext.listener_arn
        ]
      }

      target_group {
        name = module.alb_lbext.tg_active_name
      }

      target_group {
        name = module.alb_lbext.tg_standby_name
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  trigger_configuration {
    trigger_events = [
      "DeploymentSuccess",
      "DeploymentFailure",
      "DeploymentRollback"
    ]
    trigger_name       = "deployment-notifications"
    trigger_target_arn = var.codedeploy_sns_topic_arn
  }
  tags = {
    Service       = local.service_name
    ProductDomain = local.product_domain
    Environment   = var.environment
  }
}