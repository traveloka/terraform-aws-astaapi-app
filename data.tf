data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
  zone_id = "${var.route53_private_zone_id}"
}

data "aws_iam_policy_document" "app" {
  statement {
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

    resources = [
      "${var.allow_read_s3_arn}",
    ]
  }

  statement {
    sid    = "AllowWriteToS3"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "${var.allow_write_s3_arn}",
    ]
  }
}