/*
Author: <Jason Yin> (jasonyin@live.com)
File: output.tf (c) 2023
Created: 2023-04-04T17:13:31.374Z
*/

output "output_namespace" {
  value = data.oci_objectstorage_namespace.ns.namespace
}

output "output_lake_buckets" {
  description = "a list of buckets created for delta lake"
  value       = [for bucket in data.oci_objectstorage_bucket_summaries.lake_buckets.bucket_summaries : bucket.name]
}