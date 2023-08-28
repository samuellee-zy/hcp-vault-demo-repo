# TFC Setup

This repo will contain everything you need to configure your Terraform Cloud environment to work with this repo Vault configurations

## Table of Contents

- [Prerequisites](#prerequisites)
- [How-to Steps](#steps)
- [Features](#features)

## Prerequisites

It's expected that to be successful in using this repo, users should know the following:

1. TFC Organisation Name

_Note: If you're using terraform variables, replace the value in the provider.tf file, otherwise set these as env variables_

## How-to Steps

The following is a step-by-step walkthrough of how to use 01-tfc-setup:

1. Assuming that you have cloned this repo onto your own machine, change into this directory with your terminal: `cd 01-tfc-setup`
2. Run `terraform login` - this will setup your local machine to authenticate and work with Terraform Cloud
3. Terraform login should take you to a page that prompts you to create a [User API Token](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-login#generate-a-token); add the token to the cli
4. Once you're authenticated, go into variables.tf and change the default value of the `tfc_org_name` variable to your Organisation Name
5. Run `terraform init` - this will get terraform to download relevant provider and modules to use in the provisioning process
6. Run `terraform apply --auto-approve` - this will deploy the resources specific in the Terraform config file
7. Replace the Values in the `AWS_CREDS_SETUP`, `HCP_CREDS_SETUP` and `TFE_TOKEN` variable sets

## Features

The following will be provisioned as a result of the terraform configuration file:

| Resources       | Feature                                                                                           |
| --------------- | ------------------------------------------------------------------------------------------------- |
| Project         | A high-level construct that hosts relevant workspaces for the demo                                |
| Workspaces      | Workspaces that will contain relevant information to deploy and provision resources               |
| Variable Set(s) | Logical grouping of variables that can be re-used for current and future workspaces               |
| Variable(s)     | Key-Value pairs storing terraform or environment variables for use with the provisioning workflow |
