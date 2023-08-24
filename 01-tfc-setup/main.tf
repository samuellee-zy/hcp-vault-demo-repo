resource "tfe_project" "hcpv-demo" {
  organization = var.tfc_org_name
  name         = "hcpv-demo"
}

resource "tfe_workspace" "hcpv-cluster" {
  name         = "hcpv-cluster"
  organization = var.tfc_org_name
  tag_names    = ["hcpv", "cluster", "demo"]
  project_id   = tfe_project.hcpv-demo.id
}

resource "tfe_workspace" "hcpv-control-group" {
  name         = "hcpv-control-group"
  organization = var.tfc_org_name
  tag_names    = ["hcpv", "control-group", "demo"]
  project_id   = tfe_project.hcpv-demo.id
}
