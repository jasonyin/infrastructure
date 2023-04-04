/*
Author: <Jason Yin> (jasonyin@live.com)
File: main.tf (c) 2023
Created: 2023-04-04T17:40:00.885Z
*/

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 4.65.0"
    }
  }
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

module "network" {
  source = "./network"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
}

/*module "compute" {
  source     = "./compute"
  depends_on = [module.network]

  compartment_id      = var.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  cluster_subnet_id   = module.network.cluster_subnet.id
  permit_ssh_nsg_id   = module.network.permit_ssh.id
  ssh_authorized_keys = var.ssh_authorized_keys

  cidr_blocks = local.cidr_blocks
}

*/

module "object_storage" {
  source = "./object_storage"

  compartment_id = var.compartment_id
  tenant_id      = var.tenancy_ocid
}