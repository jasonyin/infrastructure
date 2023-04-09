/*
Author: <Jason Yin> (jasonyin@live.com)
File: provider.tf (c) 2023
Created: 2023-04-05T02:40:08.903Z
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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/k3s"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/k3s"
}