variable "aws_region" {
  type        = string
  description = "AWS default region"
}

variable "aws_default_tags" {
  type        = map(any)
  description = "Default tags to attach to the AWS provider"
  default     = {}
}
