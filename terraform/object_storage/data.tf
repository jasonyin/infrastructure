data "oci_objectstorage_namespace" "ns" {
  #Optional
  compartment_id = var.compartment_id
}

data "oci_objectstorage_bucket_summaries" "bronze_bucket" {
  compartment_id = var.compartment_id
  namespace = data.oci_objectstorage_namespace.ns.namespace

  filter {
    name   = "name"
    values = [oci_objectstorage_bucket.bronze_bucket.name]
  }
}