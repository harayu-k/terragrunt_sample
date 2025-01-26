// prod環境の親設定ファイル
locals {
  environment = "${replace(replace(replace(get_path_from_repo_root(), "environments/", ""), path_relative_to_include(), ""), "/", "")}"
  variables   = read_terragrunt_config(find_in_parent_folders("envs/env_${local.environment}.hcl"))
  module_name = basename(path_relative_to_include())
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    region  = "ap-northeast-1"
    bucket  = "terragrunt-state-sugar-sample-${local.environment}" //Stateを格納するバケット[^1]
    key     = "${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_version = "~> 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Managed = "Terragrunt"
    }
  }
}
EOF
}

inputs = {
  variables = local.variables.locals
}
