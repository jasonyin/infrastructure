/*
Author: <Jason Yin> (jasonyin@live.com)
File: main.tf (c) 2023
Created: 2023-04-04T17:13:25.068Z
*/

data "oci_objectstorage_namespace" "ns" {
  #Optional
  compartment_id = var.tenancy_ocid
}


// resources for buckets
resource "oci_objectstorage_bucket" "bronze_bucket" {
  #Required
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "bronze"
}

resource "oci_objectstorage_bucket" "silver_bucket" {
  #Required
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "silver"
}

resource "oci_objectstorage_bucket" "gold_bucket" {
  #Required
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "gold"
}

data "oci_objectstorage_bucket_summaries" "lake_buckets" {
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace

  filter {
    name = "name"
    values = [
      oci_objectstorage_bucket.bronze_bucket.name,
      oci_objectstorage_bucket.silver_bucket.name,
      oci_objectstorage_bucket.gold_bucket.name
    ]
  }
}