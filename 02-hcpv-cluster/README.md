# HCP Vault Deployment

This repo contains demos built around HCP Vault. This repo aims to assist with standing up your own HCP Vault environment.

## Table of Contents

- [Prerequisites](#prerequisites)
- [How-to Steps](#steps)
- [Features](#features)

## Prerequisites

Assuming that you have set the AWS creds, HCP creds and TFE token variable sets, You will need to configure the following variables as part of this folder workflow:

| Name           | Location                         |
| -------------- | -------------------------------- |
| project_id     | provider.tf (hcp provider block) |
| region         | variables.tfvars                 |
| hcpv_name      | variables.tfvars                 |
| cloud_provider | variables.tfvars                 |
| tier           | variables.tfvars                 |

_Note: If you're using terraform variables, replace the value in the provider.tf file, otherwise set these as env variables_

## How-to Steps

The following is a step-by-step walkthrough of how to use 01-tfc-setup:

1. Assuming that you have cloned this repo onto your own machine, change into this directory with your terminal: `cd ../02-hcpv-cluster`
2. As per the prerequisites, change the `project_id` in the `provider.tf` file for the hcp provider, and all relevant values in the `variables.tfvars` file
3. Run `terraform init`
   - This will get terraform to download relevant provider and modules to use in the provisioning process
4. Run `terraform apply --auto-approve -var-file variables.tfvars`
   - This will deploy the resources specific in the Terraform config file

_Note: We're not using TFC managed runners here to reduce complexity, instead this run will be done locally and the state file will be managed in the same folder as well (becareful not to push the state file to github!)_

## Features

The following will be provisioned as a result of the terraform configuration file:

| Resources                     | Feature                                                                                                      |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| HCP Vault                     | SaaS HashiCorp Vault deployed on the HashiCorp Cloud Platform                                                |
| HCP HVN                       | HashiCorp Virtual Networks, delegated an IPv4 CIDR range for HCP to use to create resources in cloud network |
| HCP Vault Cluster Admin Token | Admin token needed to make configuration changes to HCP Vault                                                |
