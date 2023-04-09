/*
Author: <Jason Yin> (jasonyin@live.com)
File: server.tf (c) 2023
Created: 2023-04-05T16:13:48.057Z
*/

resource "random_password" "cluster_token" {
  length = 64
}

resource "random_password" "sqlpassword" {
  length = 24
}

resource "oci_core_instance" "server" {
  availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains.0.name
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E2.1.Micro"

  display_name = "${var.project_name}_server"

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    display_name     = "primary"
    assign_public_ip = true
    hostname_label   = "server"
  }

  agent_config {
    plugins_config {
      name          = "OS Management Service Agent"
      desired_state = "DISABLED"
    }
  }

  source_details {
    source_id   = data.oci_core_images.amd64.images.0.id
    source_type = "image"
  }

  metadata = {
    "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    "user_data" = base64encode(templatefile("${path.module}/cloud-init/cloud-init.template.yaml", {
      bootstrap_sh_content = base64gzip(local.server_template)
    }))
  }

  lifecycle {
    ignore_changes = [
      source_details
    ]
  }
}

locals {
  server_template = templatefile("${path.module}/scripts/server.template.sh", {
    cluster_token = random_password.cluster_token.result
  })
}