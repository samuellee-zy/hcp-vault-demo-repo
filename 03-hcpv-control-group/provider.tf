terraform {
  cloud {
    organization = "samuellee-dev"
    workspaces {
      name = "hcpv-control-group"
    }
  }
  required_providers {
    tfe = {
      version = "~> 0.48.0"
    }
    aws = {
      version = "~> 5.13.1"
    }
    vault = {
      version = "~> 3.19.0"
    }
    hcp = {
      version = "~> 0.69.0"
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
