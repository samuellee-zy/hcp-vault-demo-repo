output "hcp-aws-networking-peering-self_link" {
  value = hcp_aws_network_peering.dev.self_link
}

output "postgres-db-endpoint" {
  value = aws_db_instance.postgres.address
}

output "route-table-id" {
    value = module.vpc.public_route_table_ids
}