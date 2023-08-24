### SERTUP HCP VAULT WITH AWS PEERING ###
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




### SETUP AWS RESOURCES FOR Database Secrets Engine ###
data "aws_availability_zones" "available" {}

data "tfe_outputs" "hcpv-cluster" {
  workspace    = var.vault_workspace_name
  organization = var.org_name
}

data "aws_vpc" "vpc" {
  id = module.vpc.vpc_id
}

resource "aws_db_subnet_group" "education" {
  name       = "db-demo"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "db-dynamic-creds"
  }
}

resource "aws_security_group" "rds" {
  name   = "demo_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["${data.tfe_outputs.hcpv-cluster.values.hvn-cidr-block}"]
  }

  tags = {
    Name = "demo_rds"
  }
}

resource "aws_db_parameter_group" "education" {
  name   = "education"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

provider "random" {}

resource "random_pet" "random" {
  length = 1
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.db_name}-${random_pet.random.id}"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.8"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

### VAULT CONFIG FOR DB SECRETS ENGINE ###
resource "vault_database_secrets_mount" "db" {
  depends_on = [module.vpc]
  path       = "db"

  postgresql {
    name              = "db2"
    username          = var.db_username
    password          = var.db_password
    connection_url    = "postgresql://{{username}}:{{password}}@${aws_db_instance.postgres.endpoint}/postgres"
    verify_connection = true
    allowed_roles = [
      "dev",
    ]
  }
}

resource "vault_database_secret_backend_role" "dev2" {
  name    = "dev"
  backend = vault_database_secrets_mount.db.path
  db_name = vault_database_secrets_mount.db.postgresql[0].name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
  ]
}
