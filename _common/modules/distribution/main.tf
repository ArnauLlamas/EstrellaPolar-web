locals {
  s3_origin_id = "S3Origin"
}

data "aws_cloudfront_cache_policy" "selected" {
  name = "Managed-CachingOptimized"
}

# trivy:ignore:AVD-AWS-0011 Distribution does not utilise a WAF.
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_access_control_id = var.origin_access_control_id
    origin_id                = local.s3_origin_id
  }

  enabled = true

  # Enabled through free tier plan check lifecycle policy below to override
  # price_class = "PriceClass_100"
  # web_acl_id  = null

  default_root_object = "index.html"
  http_version        = "http2and3"

  aliases = var.web_domains

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    cache_policy_id = data.aws_cloudfront_cache_policy.selected.id

    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.modify_response_headers.arn
    }

    dynamic "function_association" {
      for_each = var.domain_redirect != null ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.domain_redirect[0].arn
      }
    }
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404"
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      # locations        = []
      locations = ["IE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_web_certificate.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [price_class, web_acl_id]
  }
}
