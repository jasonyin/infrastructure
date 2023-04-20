/*
Author: <Jason Yin> (jasonyin@live.com)
File: helm_release.tf (c) 2023
Created: 2023-04-19T16:46:50.032Z
*/

resource "helm_release" "jupyterhub" {
  name       = "jupyterhub"
  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = "jupyterhub"

  values = [
    file("${path.module}/configs/jupyterhub_values.yaml")
  ]
}

resource "helm_release" "spark-operator" {
  name             = "sparkoperator"
  repository       = "https://googlecloudplatform.github.io/spark-on-k8s-operator"
  chart            = "spark-operator"
  namespace        = "sparkoperator"
  create_namespace = true

  values = [
    file("${path.module}/configs/sparkoperator_values.yaml")
  ]
}
