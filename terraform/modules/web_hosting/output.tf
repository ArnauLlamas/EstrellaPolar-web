output "s3_regional_domain" {
  value = aws_s3_bucket.web_hosting.bucket_regional_domain_name
}

output "s3_arn" {
  value = aws_s3_bucket.web_hosting.arn
}
