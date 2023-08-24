module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name                 = "demo"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_arn" "peer" {
  arn = module.vpc.vpc_arn
}

resource "hcp_aws_network_peering" "dev" {
  hvn_id          = data.tfe_outputs.hcpv-cluster.values.hvn-id
  peering_id      = "dev"
  peer_vpc_id     = module.vpc.vpc_id
  peer_account_id = module.vpc.vpc_owner_id
  peer_vpc_region = data.aws_arn.peer.region
}

resource "hcp_hvn_route" "main-to-dev" {
  hvn_link         = data.tfe_outputs.hcpv-cluster.values.hvn-self-link
  hvn_route_id     = "main-to-dev"
  destination_cidr = module.vpc.vpc_cidr_block
  target_link      = hcp_aws_network_peering.dev.self_link
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.dev.provider_peering_id
  auto_accept               = true
}

data "aws_route_table" "selected" {
  route_table_id = module.vpc.public_route_table_ids[0]
}

resource "aws_route" "hcp" {
  route_table_id            = data.aws_route_table.selected.route_table_id
  destination_cidr_block    = data.tfe_outputs.hcpv-cluster.values.hvn-cidr-block
  vpc_peering_connection_id = hcp_aws_network_peering.dev.provider_peering_id
}
