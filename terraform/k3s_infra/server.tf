/*
Author: <Jason Yin> (jasonyin@live.com)
File: server.tf (c) 2023
Created: 2023-04-05T16:13:48.057Z
*/

resource "random_password" "cluster_token" {
  length = 64
}

resource "oci_core_instance" "primary_server" {
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

  source_details {
    source_id   = data.oci_core_images.amd64.images.0.id
    source_type = "image"
  }

  lifecycle {
    ignore_changes = [
      source_details
    ]
  }

  agent_config {
    plugins_config {
      name          = "OS Management Service Agent"
      desired_state = "DISABLED"
    }
  }

  metadata = {
    "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    "user_data" = base64encode(templatefile("${path.module}/cloud-init/cloud-init.template.yaml", {
      bootstrap_sh_content = base64gzip(templatefile("${path.module}/cloud-init/scripts/server.template.sh", {
        cluster_token = random_password.cluster_token.result
        sqlpassword = random_password.sqlpassword.result
        first_server  = "true"
      }))
    }))
  }
}

# resource "oci_core_instance" "secondary_servers" {
#   count = 1
#   availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains.0.name
#   compartment_id      = var.compartment_id
#   shape               = "VM.Standard.E2.1.Micro"

#   display_name = "${var.project_name}_server_${count.index + 1}"

#   create_vnic_details {
#     subnet_id        = oci_core_subnet.public_subnet.id
#   }

#   metadata = {
#     "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
#     "user_data" = base64encode(templatefile("${path.module}/cloud-init/cloud-init.template.yaml", {
#       bootstrap_sh_content = base64gzip(templatefile("${path.module}/cloud-init/scripts/server.template.sh", {
#     cluster_token = random_password.cluster_token.result
#     first_server = "false"
#   }))
#     }))
#   }

#   source_details {
#     source_id   = data.oci_core_images.amd64.images.0.id
#     source_type = "image"
#   }

#   lifecycle {
#     ignore_changes = [
#       source_details
#     ]
#   }

#   agent_config {
#     plugins_config {
#       name          = "OS Management Service Agent"
#       desired_state = "DISABLED"
#     }
#   }

#   depends_on = [oci_core_instance.primary_server]
# }