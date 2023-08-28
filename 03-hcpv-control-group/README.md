# HCP Vault Control Groups Demo

This folder contains all the necessary Terraform code to configure your HCP Vault cluster for the Control Groups demo

## Table of Contents

- [Prerequisites](#prerequisites)
- [How-to Steps](#steps)
- [Features](#features)

## Prerequisites

Assuming that you have set the AWS creds, HCP creds and TFE token variable sets, You will need to configure the following variables as part of this folder workflow:

| Name                 | Location         |
| -------------------- | ---------------- |
| org_name             | variables.tfvars |
| vault_workspace_name | variables.tfvars |
| workspace_name       | variables.tfvars |

_Note: If you're using terraform variables, replace the value in the provider.tf file, otherwise set these as env variables_

## How-to Steps

The following is a step-by-step walkthrough of how to use 01-tfc-setup:

1. Assuming that you have cloned this repo onto your own machine, change into this directory with your terminal: `cd ../03-hcpv-control-group`
2. Change the variables values in the `variables.tfvars` file. The `vault_workspace_name` must indicate the Terraform Cloud workspace name that you've previously used to deploy the HCP Vault Cluster. By default the workspace name should be _hcpv-control-group_ if you're using the previous terraform code to deploy
3. As per the prerequisites, change the `org_name` and `workspace_name` in the `provider.tf` file for the tfe provider. This should match the same values as in the `variables.tfvars` file
4. Run `terraform init`
   - This will get terraform to download relevant provider and modules to use in the provisioning process
5. Run `terraform apply --auto-approve -var-file variables.tfvars`
   - This will deploy the resources specific in the Terraform config file

_Note: We're not using TFC managed runners here to reduce complexity, instead this run will be done locally and the state file will be managed in the same folder as well (becareful not to push the state file to github!)_

## Features

The following will be provisioned as a result of the terraform configuration file:

| Resources               | Feature                                                                                                                |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Entities                | Creates Entities (Adam, Anna and Sam) in the Vault                                                                     |
| KV V2 Secrets Engine    | Spins up a [KV V2 Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2)                         |
| Database Secrets Engine | Spins up a [Postgres Database Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/databases/postgresql) |
| AWS RDS                 | Spins up an AWS Postgres RDS                                                                                           |
| ACL policies            | Spins up a Dev and Manager policies for use to access specific paths and control group permissions                     |
