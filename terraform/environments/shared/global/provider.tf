provider "aws" {
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"

  default_tags {
    tags = var.aws_default_tags
  }
}
