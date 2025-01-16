variable "bucket_name" {
  type        = string
  description = "S3 Bucket name that will host the static website"
}

variable "name_tag" {
  type        = string
  description = "Value of the 'Name' tag of the S3 bucket that will host the static website"
}

variable "cdn_origin_access_arn" {
  type        = string
  description = "Origin Access for the S3 Policy to allow traffic only from Cloudfront"
}
