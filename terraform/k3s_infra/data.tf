/*
Author: <Jason Yin> (jasonyin@live.com)
File: data.tf (c) 2023
Created: 2023-04-05T02:29:36.396Z
*/

data "oci_identity_availability_domains" "ad_list" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "images" {
  compartment_id = var.compartment_id
}

data "oci_identity_compartment" "default" {
  id = var.compartment_id
}

data "oci_core_images" "aarch64" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"

  filter {
    name   = "display_name"
    values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}

data "oci_core_images" "amd64" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"

  filter {
    name   = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}