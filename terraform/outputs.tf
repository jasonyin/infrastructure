/*
Author: <Jason Yin> (jasonyin@live.com)
File: outputs.tf (c) 2023
Created: 2023-04-04T17:13:43.849Z
*/

/*
output "output_oci_object_storage_namespace" {
  value = format("object storage namespace: //%s", module.object_storage.output_namespace)
}

output "output_oci_object_storage_lake_buckets" {
  value = module.object_storage.output_lake_buckets
}

output "output_network_vcn" {
  value = module.network.output_vcn
}*/

output "instance" {
  value = nonsensitive(module.k3s_infra.server_metadata.user_data)
}