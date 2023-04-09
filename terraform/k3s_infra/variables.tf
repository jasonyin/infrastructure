/*
Author: <Jason Yin> (jasonyin@live.com)
File: variables.tf (c) 2023
Created: 2023-04-05T02:30:09.426Z
*/

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint of the key to use for signing"
  type        = string
}

variable "private_key_path" {
  description = "Private key path to use for signing"
  type        = string
}

variable "region" {
  description = "The region to connect to. Default: eu-frankfurt-1"
  type        = string
  default     = "us-phoenix-1"
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "The user OCID."
  type        = string
}

variable "ssh_authorized_keys" {
  description = "List of authorized SSH keys"
  type        = list(any)
}

variable "vcn_subnet" {
  description = "The VCN subnet CIDRs."
  type        = string
}

variable "private_subnet" {
  description = "The private subnet CIDRs."
  type        = string
}

variable "public_subnet" {
  description = "The public subnet CIDRs."
  type        = string
}

variable "whitelist_subnets" {
  description = "CIDRs of the network, use index 0 for everything"
  type        = list(any)
}

variable "freetier_worker_ad_list" {}
variable "freetier_server_ad_list" {}
