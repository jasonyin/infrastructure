data "oci_objectstorage_namespace" "ns" {
  #Optional
  compartment_id = var.tenant_id
}


// resources for buckets
resource "oci_objectstorage_bucket" "bronze_bucket" {
    #Required
    compartment_id = var.compartment_id
    namespace = data.oci_objectstorage_namespace.ns.namespace
    name = "bronze"

/*     #Optional
    access_type = var.bucket_access_type
    auto_tiering = var.bucket_auto_tiering
    defined_tags = {"Operations.CostCenter"= "42"}
    freeform_tags = {"Department"= "Finance"}
    kms_key_id = oci_kms_key.test_key.id
    metadata = var.bucket_metadata
    object_events_enabled = var.bucket_object_events_enabled
    storage_tier = var.bucket_storage_tier
    retention_rules {
        display_name = var.retention_rule_display_name
        duration {
            #Required
            time_amount = var.retention_rule_duration_time_amount
            time_unit = var.retention_rule_duration_time_unit
        }
        time_rule_locked = var.retention_rule_time_rule_locked
    }
    versioning = var.bucket_versioning */
}

data "oci_objectstorage_bucket_summaries" "bronze_bucket" {
  compartment_id = var.compartment_id
  namespace = data.oci_objectstorage_namespace.ns.namespace

  filter {
    name   = "name"
    values = [oci_objectstorage_bucket.bronze_bucket.name]
  }
}