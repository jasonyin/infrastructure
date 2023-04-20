/*
Author: <Jason Yin> (jasonyin@live.com)
File: outputs.tf (c) 2023
Created: 2023-04-05T17:22:18.041Z
*/

output "server_metadata" {
  value = module.k3s_infra.server_metadata
}
