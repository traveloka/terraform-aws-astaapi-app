module "lb_sg_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"
  name_prefix   = "${local.service_name}-lbext"
  resource_type = "security_group"
}

resource "aws_security_group" "lbext_sg" {
  name        = module.lb_sg_name.name
  description = "Security group for ${local.service_name}-lbext"

  vpc_id = var.vpc_id

  tags = {
    Name          = module.lb_sg_name.name
    Service       = local.service_name
    ProductDomain = local.product_domain
    Environment   = var.environment
    Description   = "Security group for ${local.service_name}-lbext"
    ManagedBy     = "terraform"
  }
}

module "app_sg_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"
  name_prefix   = "${local.service_name}-app"
  resource_type = "security_group"
}

resource "aws_security_group" "app_sg" {
  name        = module.app_sg_name.name
  description = "Security group for ${local.service_name}-app"

  vpc_id = var.vpc_id

  tags = {
    Name          = module.app_sg_name.name
    Service       = local.service_name
    ProductDomain = local.product_domain
    Environment   = var.environment
    Description   = "Security group for ${local.service_name}-app"
    ManagedBy     = "terraform"
  }
}

########################
# Security Group Rules #
########################
