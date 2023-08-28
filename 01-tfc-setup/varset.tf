resource "tfe_variable_set" "aws-creds-setup" {
  name         = "AWS Creds Setup"
  description  = "AWS Credentials if needed"
  organization = var.tfc_org_name
  global       = true
}

resource "tfe_variable" "aws-access-key-id" {
  key             = "AWS_ACCESS_KEY_ID"
  value           = "INSERT_AWS_ACCESS_KEY_ID"
  category        = "env"
  variable_set_id = tfe_variable_set.aws-creds-setup.id
}

resource "tfe_variable" "aws-secret-access-key" {
  key             = "AWS_SECRET_ACCESS_KEY"
  value           = "INSERT_AWS_SECRET_ACCESS_KEY"
  category        = "env"
  variable_set_id = tfe_variable_set.aws-creds-setup.id
  sensitive       = true
}

resource "tfe_variable_set" "hcp-creds-setup" {
  name         = "HCP Creds Setup"
  description  = "HCP Credentials if needed"
  organization = var.tfc_org_name
  global       = true
}

resource "tfe_variable" "hcp-client-id" {
  key             = "HCP_CLIENT_ID"
  value           = "INSERT_HCP_CLIENT_ID"
  category        = "env"
  variable_set_id = tfe_variable_set.hcp-creds-setup.id
}

resource "tfe_variable" "hcp-client-secret" {
  key             = "HCP_CLIENT_SECRET"
  value           = "INSERT_HCP_CLIENT_SECRET"
  category        = "env"
  variable_set_id = tfe_variable_set.hcp-creds-setup.id
  sensitive       = true
}

resource "tfe_variable_set" "tfe-token" {
  name         = "TFE Token"
  description  = "Token to access TFC environment and workspaces"
  organization = var.tfc_org_name
  global       = true
}

resource "tfe_variable" "tfe-token" {
  key             = "TFE_TOKEN"
  value           = "INSERT_USER_API_TOKEN_VALUE"
  category        = "env"
  variable_set_id = tfe_variable_set.tfe-token.id
  sensitive       = true
}
