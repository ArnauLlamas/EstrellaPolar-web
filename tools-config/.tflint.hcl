# How to configure this file
# https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md

# TODO Pass this file to a repository to have it always updated and synced cross projects

config {
  module = true
}

plugin "aws" {
  enabled    = true
  deep_check = true
  version    = "0.13.4"
  source     = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}