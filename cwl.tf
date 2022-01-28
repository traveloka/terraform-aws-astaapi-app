resource "aws_cloudwatch_log_group" "cwl" {
  name = "/tvlk/app-java/${local.service_name}/console"

  retention_in_days = 14

  tags = {
    Name          = "/tvlk/app-java/${local.service_name}/console"
    ProductDomain = local.product_domain
    Service       = local.service_name
    Environment   = var.environment
    Description   = "Cloudwatch Log Group for ${local.service_name}-app ECS"
    ManagedBy     = "terraform"
  }
}