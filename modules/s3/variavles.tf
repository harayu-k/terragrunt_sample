variable "variables" {}

locals {
  variables = yamldecode(var.variables)

  app_name    = local.variables.app_name
  environment = local.variables.environment
}
