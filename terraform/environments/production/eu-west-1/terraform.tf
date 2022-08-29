terraform {
  backend "s3" {
    bucket = "estrellapolar-tf-states"
    key    = "web/production/eu-west-1/terraform.state"
    region = "eu-west-1"
  }
  required_version = "~> 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
  }
}
