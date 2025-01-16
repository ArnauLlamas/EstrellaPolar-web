# How to configure this file
# https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md

config {
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled    = true
  deep_check = true
  version    = "0.37.0"
  source     = "github.com/terraform-linters/tflint-ruleset-aws"
}
