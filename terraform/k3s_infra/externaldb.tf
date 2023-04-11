/*
Author: <Jason Yin> (jasonyin@live.com)
File: externaldb.tf (c) 2023
Created: 2023-04-05T17:47:12.270Z
*/

resource "random_password" "sqlpassword" {
  length = 24
}

resource "oci_core_instance" "externaldb" {
  availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains.0.name
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E2.1.Micro"

  display_name = "${var.project_name}_externaldb"

  create_vnic_details {
    subnet_id        = oci_core_subnet.db_public_subnet.id
    display_name     = "primary"
    assign_public_ip = true
    hostname_label   = "externaldb"
  }

  source_details {
    source_id   = data.oci_core_images.amd64.images.0.id
    source_type = "image"
  }

  metadata = {
    "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    "user_data" = base64encode(templatefile("${path.module}/cloud-init/cloud-init.template.yaml", {
      bootstrap_sh_content = base64gzip(templatefile("${path.module}/cloud-init/scripts/externaldb.template.sh", {
        sqlpassword = random_password.sqlpassword.result
      }))
    }))
  }

  lifecycle {
    ignore_changes = [
      source_details
    ]
  }
}