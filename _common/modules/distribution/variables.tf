variable "environment" {
  type        = string
  description = "The environment where the website will be deployed"
}

variable "root_domain" {
  type        = string
  description = "The domain where the website will be hosted, used to order certificates"
}

variable "web_domains" {
  type        = list(string)
  description = "List of full domains from where the website will be served"
}

variable "origin_access_control_id" {
  type        = string
  description = "ID of default S3 origin access control"
}

variable "bucket_arn" {
  type = string
}

variable "bucket_regional_domain_name" {
  type = string
}
