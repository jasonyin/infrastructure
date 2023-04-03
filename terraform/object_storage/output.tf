output "namespace" {
  value = data.oci_objectstorage_namespace.ns.namespace
}

output "buckets" {
  value = data.oci_objectstorage_bucket_summaries.bronze_bucket.bucket_summaries
}