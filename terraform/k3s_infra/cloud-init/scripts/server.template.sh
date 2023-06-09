#!/bin/bash
set -x

yum update -y oracle-cloud-agent
systemctl disable firewalld --now

iptables -A INPUT -i ens3 -p tcp --dport 6443 -j DROP
iptables -I INPUT -i ens3 -p tcp -s 10.0.0.0/8  --dport 6443 -j ACCEPT

curl -sfL https://get.k3s.io | K3S_TOKEN='${cluster_token}' sh -s - server --cluster-init


# while ! nc -z localhost 6443; do
#   sleep 1
# done

mkdir /home/opc/.kube
cp /etc/rancher/k3s/k3s.yaml /home/opc/.kube/config
sed -i "s/127.0.0.1/$(curl -s ifconfig.co)/g" /home/opc/.kube/config
chown opc:opc /home/opc/.kube/ -R

export KUBECONFIG=~/.kube/config
iptables -D INPUT -i ens3 -p tcp --dport 6443 -j DROP