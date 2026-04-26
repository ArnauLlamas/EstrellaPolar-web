# trivy:ignore:AVD-AWS-0090
resource "aws_s3_bucket" "web_hosting" {
  bucket              = var.bucket_name
  object_lock_enabled = false
}

# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "web_hosting_encryption" {
  bucket = aws_s3_bucket.web_hosting.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "web_hosting_cors" {
  bucket = aws_s3_bucket.web_hosting.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "web_hosting_pab" {
  bucket = aws_s3_bucket.web_hosting.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
