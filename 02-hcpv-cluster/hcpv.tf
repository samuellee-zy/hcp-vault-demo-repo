resource "hcp_hvn" "hcpv-hvn" {
  hvn_id         = "hvn"
  cloud_provider = var.cloud_provider
  region         = var.region
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_vault_cluster" "hcpv-cluster" {
  cluster_id = var.hcpv_name
  hvn_id     = hcp_hvn.hcpv-hvn.hvn_id
  tier       = var.tier
  lifecycle {
    prevent_destroy = false
  }
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "hcpv-cluster-token" {
  cluster_id = hcp_vault_cluster.hcpv-cluster.cluster_id
}
