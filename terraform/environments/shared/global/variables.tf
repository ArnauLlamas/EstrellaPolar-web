variable "aws_default_tags" {
  type        = map(any)
  description = "Default tags to attach to the AWS provider"
  default     = {}
}

variable "bucket_name" {
  type        = string
  description = "S3 Bucket name that will host the static website"
}

variable "bucket_name_tag" {
  type        = string
  description = "Value of the 'Name' tag of the S3 bucket that will host the static website"
}

variable "root_domain" {
  type        = string
  description = "The domain where the website will be hosted, used to order certificates"
}

variable "web_domains" {
  type        = list(string)
  description = "List of full domains from where the website will be served"
}
