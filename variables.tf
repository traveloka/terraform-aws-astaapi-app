variable "tg_health_check" {
  type        = map(string)
  description = "Load balancer target group Health Check configuration block"
  default = {
    interval            = 30
    path                = "/healthcheck"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }
}

variable "environment" {
  type        = string
  description = "The environment where the service runs"
}

variable "custom_container_definitions" {
  type        = string
  description = "The ECS container definition of the service. Use the return of terraform's `templatefile` function"
  default     = ""
}

variable "ecs_healthcheck_grace_period" {
  description = "ECS Healthcheck Grace Period"
  type        = string
  default     = 60
}

variable "ecs_initial_capacity" {
  description = "ECS Initial Capacity"
  type        = string
  default     = 1
}

variable "ecs_cpu" {
  description = "ECS CPU Size. Default 512"
  type        = string
  default     = 512
}

variable "ecs_memory" {
  description = "ECS Memory Size. Default 1024"
  type        = string
  default     = 1024
}

variable "ecs_subnet_ids" {
  type        = list(string)
  description = "The subnets where ECS tasks should run"
}

variable "tg_deregistration_delay" {
  default     = 30
  description = "Wait for this many seconds before deregistering targets from the LB"
}

variable "lb_subnet_ids" {
  type        = list(string)
  description = "The subnets where the ALB should run"
}

variable "codedeploy_service_role_arn" {
  type        = string
  description = "The role arn which should be assumend by CodeDeploy"
}

variable "codedeploy_sns_topic_arn" {
  type        = string
  description = "The topic arn which should be used to publish deployment notifications"
}

variable "ecs_deployment_config" {
  type        = string
  description = "The name of the group's deployment config"
}

variable "codedeploy_app_name" {
  type        = string
  description = "The name of the CodeDeploy app under which the deployment group would be created"
}

variable "ecs_cluster_name" {
  type        = string
  description = "The name of the ECS cluster under which the fargate service would be created"
}

variable "fargate_execution_role_arn" {
  type        = string
  description = "The role with which Fargate should download images, stream logs, and retrieve secrets"
}

variable "external_listener_certificate_arn" {
  type        = string
  description = "The main certificate for the external ALB listener. Currently, you can add more certificates outside of the module"
}

variable "lb_logs_s3_bucket_name" {
  type        = string
  description = "The log bucket for the ALB"
}

variable "vpc_id" {
  type        = string
  description = "The name of the CodeDeploy app under which the deployment group would be created"
}

variable "spring_profiles" {
  description = "Spring profiles that is used for app"
  type        = string
}

variable "service_version" {
  description = "Service version of the app"
  type        = string
}

variable "dd_api_key_arn" {
  description = "Datadog API Key ARN"
  type        = string
}

variable "route53_public_zone_id" {
  description = "The zone ID of the public hosted zone that the route 53 record for the LB will be created"
  type        = string
}

variable "lb_route53_record_name" {
  description = "Override Route 53 record name created for LB, default is using service name"
  type        = string
  default     = ""
}

variable "lbext_akamai_hostname" {
  type        = string
  default     = ""
  description = "The name of Akamai hostname that point to origin LB. The default is no Akamai"
}

variable "additional_tags" {
  description = "Additional tags that will be added to the resources"
  type        = map(string)
  default     = {}
}

variable "additional_lb_security_group_ids" {
  description = "Additional Security Group's of Load Balancer"
  type        = list(string)
  default     = []
}

variable "commonec2_policy_arn" {
  description = "The ARN of the common EC2 policy that will be attached to the ECS task role"
  type        = string
}

variable "additional_ecs_service_tags" {
  type    = map(string)
  default = {}
}

variable "allow_read_s3_arn" {
  type        = list(string)
  description = "List of S3 ARNs where service can read"
  default     = []
}

variable "allow_write_s3_arn" {
  type        = list(string)
  description = "List of S3 ARNs where service can write"
  default     = []
}