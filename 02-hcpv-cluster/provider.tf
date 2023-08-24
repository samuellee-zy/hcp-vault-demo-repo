terraform {
  cloud {
    organization = "samuellee-dev"
    workspaces {
      name = "hcpv-cluster"
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

provider "hcp" {
  # client_id = "insert-service-principal-key-client-id"
  # client_secret = "insert-service-principal-key-client-secret"
  project_id = "5594ca7c-efd8-4ba6-bdbb-007bcf95cd84"
}

provider "tfe" {}

provider "vault" {
  address = hcp_vault_cluster.hcpv-cluster.vault_public_endpoint_url
}
