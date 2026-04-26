module "web_hosting" {
  source = "../web_hosting"

  bucket_name = var.bucket_name
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default-oac-${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

module "distribution" {
  source = "../distribution"
  count  = var.environment != "production" ? 0 : 1
  providers = {
    aws.main      = aws
    aws.us-east-1 = aws.us-east-1
  }

  environment = var.environment

  root_domain = var.root_domain
  web_domains = var.web_domains

  origin_access_control_id = aws_cloudfront_origin_access_control.default.id

  bucket_arn                  = module.web_hosting.s3_arn
  bucket_regional_domain_name = module.web_hosting.s3_regional_domain

  domain_redirect = {
    from = "estrellapolar.org"
    to   = "patriciabenejam.com"
  }
}

module "patriciabenejam_distribution" {
  source = "../distribution"
  providers = {
    aws.main      = aws
    aws.us-east-1 = aws.us-east-1
  }

  environment = var.environment

  root_domain = var.pb_root_domain
  web_domains = var.pb_web_domains

  origin_access_control_id = aws_cloudfront_origin_access_control.default.id

  bucket_arn                  = module.web_hosting.s3_arn
  bucket_regional_domain_name = module.web_hosting.s3_regional_domain
}

data "aws_iam_policy_document" "web_hosting_iam_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${module.web_hosting.s3_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = var.environment == "production" ? [module.distribution[0].cdn.arn, module.patriciabenejam_distribution.cdn.arn] : [module.patriciabenejam_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web_hosting_policy_attachment" {
  bucket = module.web_hosting.s3_bucket
  policy = data.aws_iam_policy_document.web_hosting_iam_policy.json
}
