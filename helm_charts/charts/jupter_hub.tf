/*
Author: <Jason Yin> (jasonyin@live.com)
File: jupter_hub.tf (c) 2023
Created: 2023-04-19T16:06:40.057Z
*/

resource "helm_release" "jupter_hub" {

  name = "jupter_hub"

  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = "jupyterhub"
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
