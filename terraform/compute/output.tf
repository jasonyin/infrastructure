/*
Author: <Jason Yin> (jasonyin@live.com)
File: output.tf (c) 2023
Created: 2023-04-04T20:21:01.927Z
*/

output "ad" {
  value = data.oci_identity_availability_domain.ad_2.name
}

output "cluster_token" {
  value = random_string.cluster_token.result
}