data "aws_route53_zone" "r53_zone" {
  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_record" "web_domain" {
  for_each = toset(var.web_domains)

  allow_overwrite = true
  name            = each.key
  type            = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }

  zone_id = data.aws_route53_zone.r53_zone.zone_id
}

resource "aws_acm_certificate" "acm_web_certificate" {
  provider = aws.us-east-1

  domain_name               = var.web_domains[0]
  subject_alternative_names = [for n in range(length(var.web_domains) - 1) : var.web_domains[n + 1]]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "r53_acm_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.acm_web_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.r53_zone.zone_id
}

resource "aws_acm_certificate_validation" "acm_certificate" {
  provider = aws.us-east-1

  certificate_arn         = aws_acm_certificate.acm_web_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.r53_acm_validation_records : record.fqdn]
}
