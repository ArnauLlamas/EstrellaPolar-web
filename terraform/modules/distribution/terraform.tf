terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.28.0"
      configuration_aliases = [aws.main, aws.us-east-1]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}
