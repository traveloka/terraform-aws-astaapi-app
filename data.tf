data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
  zone_id = var.route53_public_zone_id
}

data "template_file" "container_definitions" {
  template = file("${path.module}/template/container_definitions.json")

  vars = {
    service_name      = local.service_name
    product_domain    = local.product_domain
    app_cluster       = "${local.service_name}-app"
    app_port          = local.app_port
    aws_region        = data.aws_region.current.name
    service_version   = var.service_version
    dd_api_key_arn    = var.dd_api_key_arn
    spring_profiles   = var.spring_profiles
    environment       = var.environment
    service_log_group = aws_cloudwatch_log_group.cwl.name
  }
}

data "aws_iam_policy_document" "execute_command" {
  statement {
    sid    = "AllowExecuteCommand"
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "app" {
  statement {
    sid    = "AllowReadFromParameterStore"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/tvlk-secret/${local.service_name}/*",
    ]
  }

  statement {
    sid    = "AllowReadFromS3"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = var.allow_read_s3_arn
  }

  statement {
    sid    = "AllowWriteToS3"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = var.allow_write_s3_arn
  }
}