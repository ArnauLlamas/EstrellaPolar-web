aws_default_tags = {
  Billing           = "Estrella Polar - Marketing Dept"
  Project           = "Static Website"
  Environment       = "Production"
  Terraform-Managed = true
  Terraform-Project = "https://github.com/ArnyDnD/EstrellaPolar-web"
}

bucket_name     = "estrellapolar-website-production"
bucket_name_tag = "EstrellaPolar Web"

root_domain = "estrellapolar.org"
web_domains = ["estrellapolar.org", "www.estrellapolar.org"]
