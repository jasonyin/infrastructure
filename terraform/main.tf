/*
Author: <Jason Yin> (jasonyin@live.com)
File: main.tf (c) 2023
Created: 2023-04-04T17:40:00.885Z
*/

module "k3s_infra" {
  source = "./k3s_infra"

  # General
  project_name        = "k3s_infra"
  region              = var.region
  compartment_id      = var.compartment_id
  user_ocid           = var.user_ocid
  tenancy_ocid        = var.tenancy_ocid
  private_key_path    = var.private_key_path
  fingerprint         = var.fingerprint
  ssh_authorized_keys = var.ssh_authorized_keys

  # Network
  whitelist_subnets = var.whitelist_subnets
  vcn_subnet        = var.vcn_subnet
  private_subnet    = var.private_subnet
  public_subnet     = var.public_subnet
  db_subnet         = var.db_subnet

  freetier_server_ad_list = local.freetier_server_ad_list
  freetier_worker_ad_list = local.freetier_worker_ad_list
}


/*module "network" {
  source = "./network"

  compartment_id    = var.compartment_id
  tenancy_ocid      = var.tenancy_ocid
  whitelist_subnets = var.whitelist_subnets
  vcn_subnet        = var.vcn_subnet
  private_subnet    = var.private_subnet
  public_subnet     = var.public_subnet
}

module "compute" {
  source     = "./compute"
  depends_on = [module.network]

  compartment_id      = var.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  cidr_blocks         = local.cidr_blocks
  cluster_subnet_id   = module.network.output_cluster_subnet.id
  permit_ssh_nsg_id   = module.network.output_permit_ssh.id
  ssh_authorized_keys = var.ssh_authorized_keys
}*/