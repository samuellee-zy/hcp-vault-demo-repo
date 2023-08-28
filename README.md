# HCP Vault Demo Repo

This repo will contain everything you need to deploy HCP Vault, and demo specific functions and capabilities.

## Table of Contents

- [Project Title](#project-title)
- [Prerequisites](#prerequisites)
- [Description](#description)
- [Features](#features)
- [How-to Steps](#steps)
- [Contributing](#contributing)

## Prerequisites

This repo utilises certain tools that may require additional knowledge. Where possible, a link or documentation will be provided to supplement any knowledge gaps, but please do not expect this repo to provide all the steps for you.

It's expected that to be successful in using this repo, users should know the following:

1. Terraform ([Installation Setup](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
2. Terraform Cloud ([Sign up link](https://app.terraform.io/public/signup/account))
3. HCP Vault ([Sign up link](https://portal.cloud.hashicorp.com/sign-up))
   - [Service Principal Setup](https://developer.hashicorp.com/hcp/docs/hcp/security/service-principals#create-a-service-principal)

_Note: If you're using terraform variables, replace the value in the provider.tf file, otherwise set these as env variables_

## Description

This repo contains demos built around HCP Vault. This repo aims to assist with standing up your own HCP Vault environment, with a few configurations to automatically test other features and capabilities of HCP Vault. Each of the folder starts with a number, detailing the order in which they should be applied in order to run the demo smoothly.

## Features

This Repo will help you stand up the following:

| Folder Name           | Feature                                                            |
| --------------------- | ------------------------------------------------------------------ |
| 01-tfc-setup          | Deploy relevant TFC workspaces to host each terraform provisioning |
| 02-hcpv-cluster       | Deploy HCP Vault - Plus tier                                       |
| 03-hcpv-control-group | Configures Vault Cluster to operate with Control Groups demo       |
| 09-hcpv-general-demo  | Configures Vault Cluster to run a few general Vault capabilities   |

## How-to Steps

The following walks you through how to use this repository:

1. Fork this repo (if you intend to store this into your own github account)
2. Git clone this repo into your local machine

## Contributing

Shoutout to Jamie Wright for the inspiration
