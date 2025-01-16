locals {
  aws_region = "eu-west-1"

  bucket_name     = "estrellapolar-website-testing"
  bucket_name_tag = "EstrellaPolar Web"

  root_domain = "estrellapolar.org"
  web_domains = ["testing.estrellapolar.org"]
}
