/*
Author: <Jason Yin> (jasonyin@live.com)
File: provider.tf (c) 2023
Created: 2023-04-19T17:03:44.715Z
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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
