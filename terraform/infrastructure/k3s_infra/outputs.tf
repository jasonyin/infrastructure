/*
Author: <Jason Yin> (jasonyin@live.com)
File: output.tf (c) 2023
Created: 2023-04-19T17:19:57.686Z
*/


output "server_metadata" {
  value = oci_core_instance.server.metadata
}
