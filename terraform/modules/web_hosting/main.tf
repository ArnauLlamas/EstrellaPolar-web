resource "aws_s3_bucket" "web_hosting" {
  bucket              = var.bucket_name
  object_lock_enabled = false

  tags = {
    Name = var.name_tag
  }
}

resource "aws_s3_bucket_acl" "web_hosting_acl" {
  bucket = aws_s3_bucket.web_hosting.id
  acl    = "private"
}

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

data "aws_iam_policy_document" "web_hosting_iam_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_hosting.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.cdn_origin_access_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web_hosting_policy_attachment" {
  bucket = aws_s3_bucket.web_hosting.id
  policy = data.aws_iam_policy_document.web_hosting_iam_policy.json
}
