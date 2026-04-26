variable "environment" {
  type        = string
  description = "The environment where the website will be deployed"
}

variable "bucket_name" {
  type        = string
  description = "S3 Bucket name that will host the static website"
}

variable "root_domain" {
  type        = string
  description = "The domain where the website will be hosted, used to order certificates"
}

variable "web_domains" {
  type        = list(string)
  description = "List of full domains from where the website will be served"
}

variable "pb_root_domain" {
  type        = string
  description = "The domain where the website will be hosted, used to order certificates"
}

variable "pb_web_domains" {
  type        = list(string)
  description = "List of full domains from where the website will be served"
}
