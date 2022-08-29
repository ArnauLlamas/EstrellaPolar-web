resource "aws_cloudfront_origin_access_identity" "cdn_origin" {}

module "web_hosting" {
  source = "../../../modules/web_hosting"

  bucket_name           = var.bucket_name
  name_tag              = var.bucket_name_tag
  cdn_origin_access_arn = aws_cloudfront_origin_access_identity.cdn_origin.iam_arn
}

module "distribution" {
  source = "../../../modules/distribution"
  providers = {
    aws.main      = aws
    aws.us-east-1 = aws.us-east-1
  }

  root_domain = var.root_domain
  web_domains = var.web_domains

  cdn_origin_access = {
    id   = aws_cloudfront_origin_access_identity.cdn_origin.id
    path = aws_cloudfront_origin_access_identity.cdn_origin.cloudfront_access_identity_path
  }

  bucket_arn                  = module.web_hosting.s3_arn
  bucket_regional_domain_name = module.web_hosting.s3_regional_domain
}
