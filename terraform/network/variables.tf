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

variable "ssh_managemnet_network" {
  description = "Subnet allowed to ssh to hosts"
  type        = string
}

variable "cidr_blocks" {
  description = "CIDRs of the network, use index 0 for everything"
  type        = list(any)
}