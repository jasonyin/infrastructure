#!/bin/bash
set -x

yum update -y oracle-cloud-agent
systemctl disable firewalld --now

iptables -A INPUT -i ens3 -p tcp --dport 6443 -j DROP
iptables -I INPUT -i ens3 -p tcp -s 10.0.0.0/8  --dport 6443 -j ACCEPT

curl -sfL https://get.k3s.io | K3S_TOKEN='${cluster_token}' sh -s - server --cluster-init

# check tcp to k3s and wait for 200s
for ((i=0; i<=10; i++));
do
    nc -vzw20 server.public.main.oraclevcn.com 6443;
    if [[ $? == 0 ]]
    then
        break
    fi
done

mkdir /home/opc/.kube
cp /etc/rancher/k3s/k3s.yaml /home/opc/.kube/config
sed -i "s/127.0.0.1/$(hostname -i)/g" /home/opc/.kube/config
chown opc:opc /home/opc/.kube/ -R

export KUBECONFIG=~/.kube/config
iptables -D INPUT -i ens3 -p tcp --dport 6443 -j DROP