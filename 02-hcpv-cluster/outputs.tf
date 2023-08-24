output "vault-token" {
  value     = hcp_vault_cluster_admin_token.hcpv-cluster-token.token
  sensitive = true
}

output "hcp-vault-id" {
  value = hcp_vault_cluster.hcpv-cluster.id
}

output "hcp-vault-address" {
  value = hcp_vault_cluster.hcpv-cluster.vault_public_endpoint_url
}

output "hvn-id" {
  value = hcp_hvn.hcpv-hvn.hvn_id
}

output "hvn-self-link" {
  value = hcp_hvn.hcpv-hvn.self_link
}

output "hvn-cidr-block" {
  value = hcp_hvn.hcpv-hvn.cidr_block
}
# output "aws-vpc-arn" {
#   value = aws_vpc.peer.arn
# }

# output "aws-vpc-id" {
#   value = aws_vpc.peer.id
# }

