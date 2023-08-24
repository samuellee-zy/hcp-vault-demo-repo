terraform {
  cloud {
    organization = "samuellee-dev"
    workspaces {
      name = "hcpv-demo"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "tfe" {}

provider "vault" {
  address = data.tfe_outputs.tfc-outputs.values.hcp-vault-address
  token   = data.tfe_outputs.tfc-outputs.values.vault-token
}

provider "hcp" {
  project_id = "5594ca7c-efd8-4ba6-bdbb-007bcf95cd84"
}
