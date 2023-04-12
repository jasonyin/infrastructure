/*
Author: <Jason Yin> (jasonyin@live.com)
File: dashboard.tf (c) 2023
Created: 2023-04-12T15:49:34.778Z
*/

resource "helm_release" "k3s-dashboard" {

    name = "${var.project_name}_dashboard"
  
    repository = "https://kubernetes.github.io/dashboard/"
    chart      = "kubernetes-dashboard"
    namespace  = "default"
  
    set {
      name  = "service.type"
      value = "LoadBalancer"
    }
  
    set {
      name  = "protocolHttp"
      value = "true"
    }
  
    set {
      name  = "service.externalPort"
      value = 8080
    }
   
    set {
      name  = "rbac.clusterReadOnlyRole"
      value = "true"
    }
  }
  