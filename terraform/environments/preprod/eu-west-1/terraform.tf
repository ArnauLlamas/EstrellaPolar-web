terraform {
  backend "s3" {
    bucket = "atikaroom-tf-states"
    key    = "project/preproduction/eu-west-1/terraform.state"
    region = "eu-west-1"
  }
  required_version = "~> 1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13.0"
    }
  }
}
