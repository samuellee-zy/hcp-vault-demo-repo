terraform {
  # cloud {
  #   organization = "sam-test-aws-workshop"
  #   workspaces {
  #     name = "hcpv-tfc-setup"
  #   }
  # }
  required_providers {
    tfe = {
      version = "~> 0.48.0"
    }
  }
}
