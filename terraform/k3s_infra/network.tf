/*
Author: <Jason Yin> (jasonyin@live.com)
File: network.tf (c) 2023
Created: 2023-04-05T02:29:45.360Z
*/

resource "oci_core_vcn" "main" {
  dns_label      = "main"
  cidr_block     = var.vcn_subnet
  compartment_id = var.compartment_id
  display_name   = "main"
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "main"
}

# resource "oci_core_nat_gateway" "private_subnet" {
#   compartment_id = var.compartment_id
#   vcn_id         = oci_core_vcn.main.id
#   display_name   = "private_subnet"

# }

resource "oci_core_subnet" "public_subnet" {
  cidr_block     = var.public_subnet
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "public_subnet"
  dns_label      = "public"
}

resource "oci_core_subnet" "db_public_subnet" {
  cidr_block     = var.db_subnet
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "db_public_subnet"
  dns_label      = "database"
}

resource "oci_core_subnet" "private_subnet" {
  cidr_block     = var.private_subnet
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "private_subnet"
  route_table_id = oci_core_route_table.private_subnet.id
  dns_label      = "private"
}

resource "oci_core_default_route_table" "main" {
  manage_default_resource_id = oci_core_vcn.main.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id

    description = "internet gateway"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_route_table" "private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name = "private_subnet_natgw"

  # route_rules {
  #   network_entity_id = oci_core_nat_gateway.private_subnet.id

  #   description = "k8s private to public internal"
  #   destination = "0.0.0.0/0"

  # }

  # TODO: add service gateway
}


resource "oci_core_default_security_list" "default" {
  manage_default_resource_id = oci_core_vcn.main.default_security_list_id

  # TODO: check protocol is "all"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"
  }

  #source      = ingress_security_rules.value
  dynamic "ingress_security_rules" {
    for_each = var.whitelist_subnets
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      description = "SSH"

      tcp_options {
        max = 22
        min = 22
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.whitelist_subnets
    content {
      protocol    = "6"
      source      = ingress_security_rules.value
      description = "Kubernetes API"

      tcp_options {
        max = 6443
        min = 6443
      }
    }
  }

  ingress_security_rules {
    protocol    = "17"
    source      = var.vcn_subnet
    description = "Kubernetes VXLAN"

    udp_options {
      max = 8472
      min = 8472
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.vcn_subnet
    description = "Kubernetes Metrics"

    tcp_options {
      max = 10250
      min = 10250
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.vcn_subnet
    description = "Nginx Ingress NodePort"

    tcp_options {
      max = 30080
      min = 30080
    }
  }
}