/*
Author: <Jason Yin> (jasonyin@live.com)
File: variables.tf (c) 2023
Created: 2023-04-04T17:48:50.768Z
*/

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

locals {
  cidr_blocks            = ["10.0.0.0/24"]
  ssh_managemnet_network = "1.1.1.1/32"
}