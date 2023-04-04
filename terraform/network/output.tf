/*
Author: <Jason Yin> (jasonyin@live.com)
File: output.tf (c) 2023
Created: 2023-04-04T17:48:45.951Z
*/

output "output_vcn" {
  description = "Created VCN"
  value       = oci_core_vcn.cluster_network
}

output "output_cluster_subnet" {
  description = "Subnet of the k3s cluser"
  value       = oci_core_subnet.cluster_subnet
  depends_on  = [oci_core_subnet.cluster_subnet]
}

output "output_permit_ssh" {
  description = "NSG to permit ssh"
  value       = oci_core_network_security_group.permit_ssh
}

output "output_ad" {
  value = data.oci_identity_availability_domain.ad.name
}