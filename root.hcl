locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  region_vars = read_terragrunt_config("region.hcl").locals

  aws_default_tags = jsonencode({
    Billing     = "Estrella Polar - Marketing Dept"
    Project     = "Website"
    Environment = local.env_vars.environment
    IaC         = "terragrunt"
    Repository  = "https://github.com/ArnyDnD/EstrellaPolar-web"
  })
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      default_tags {
        tags = jsondecode(
          <<-INNEREOF
            ${local.aws_default_tags}
          INNEREOF
        )
      }
    }

    provider "aws" {
      region = "us-east-1"
      alias  = "us-east-1"

      default_tags {
        tags = jsondecode(
          <<-INNEREOF
            ${local.aws_default_tags}
          INNEREOF
        )
      }
    }
  EOF
}

remote_state {
  backend = "s3"
  config = {
    disable_bucket_update = true
    encrypt               = true
    bucket                = "estrellapolar-tf-states"
    key                   = "web/${local.env_vars.environment}/${local.region_vars.aws_region}/terraform.state"
    region                = "eu-west-1"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.env_vars,
  local.region_vars,
  {
    path_to_modules_folder = get_repo_root()
  }
)
