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

variable "cdn_origin_access" {
  type = object({
    id   = string
    path = string
  })
  description = "Origin Access ID and Path for the CloudFront Distribution"
}

variable "bucket_arn" {
  type = string
}

variable "bucket_regional_domain_name" {
  type = string
}
