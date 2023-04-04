/*
Author: <Jason Yin> (jasonyin@live.com)
File: main.tf (c) 2023
Created: 2023-04-04T20:20:51.798Z
*/

data "oci_identity_availability_domain" "ad_1" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_availability_domain" "ad_2" {
  compartment_id = var.tenancy_ocid
  ad_number      = 2
}

data "oci_identity_availability_domain" "ad_3" {
  compartment_id = var.tenancy_ocid
  ad_number      = 3
}

resource "random_string" "cluster_token" {
  length           = 48
  special          = true
  numeric          = true
  lower            = true
  upper            = true
  override_special = "^@~*#%/.+:;_"
}

resource "oci_core_instance" "server_0" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad_2.name
  display_name        = "k3s_server_0"
  shape               = local.ampere_instance_config.shape_id
  source_details {
    source_id   = local.ampere_instance_config.source_id
    source_type = local.ampere_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.ampere_instance_config.ram
    ocpus         = local.ampere_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks[0], 10)
    nsg_ids    = [var.permit_ssh_nsg_id]
  }
  metadata = {
    "ssh_authorized_keys" = local.ampere_instance_config.metadata.ssh_authorized_keys
    "user_data" = base64encode(
      templatefile("${path.module}/templates/server.sh",
        {
          server_0_ip = cidrhost(var.cidr_blocks[0], 10),
          token       = random_string.cluster_token.result
      })
    )
  }
}