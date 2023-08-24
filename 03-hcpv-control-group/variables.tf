variable "org_name" {
  type    = string
  default = "samuellee-dev"
}
variable "vault_workspace_name" {
  type    = string
  default = "hcpv-cluster"
}

variable "workspace_name" {
  type    = string
  default = "hcpv-control-group"
}

variable "db_username" {
  type    = string
  default = "samuellee"
}

variable "db_password" {
  type    = string
  default = "Demo1234"
}

variable "db_name" {
  description = "Unique name to assign to RDS instance"
}

variable "region" {
  type    = string
  default = "ap-southeast-2"
}
