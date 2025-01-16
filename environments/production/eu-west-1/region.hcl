locals {
  aws_region = "eu-west-1"

  bucket_name     = "estrellapolar-website-production"
  bucket_name_tag = "EstrellaPolar Web"

  root_domain = "estrellapolar.org"
  web_domains = ["estrellapolar.org", "www.estrellapolar.org"]
}
