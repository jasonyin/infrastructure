#!/bin/bash
set -x

yum update -y oracle-cloud-agent
systemctl disable firewalld --now

iptables -A INPUT -i ens3 -p tcp --dport 6443 -j DROP
iptables -I INPUT -i ens3 -p tcp -s 10.0.0.0/8  --dport 6443 -j ACCEPT

echo 'waiting for external db connection'

k3s_primary_server_url = externaldb.database.main.oraclevcn.com

# check tcp to external db and wait for 10s
nc -vzw10 externaldb.database.main.oraclevcn.com 3306
if [ $? == 0 ] then
    break
else
    echo 'cannot connect to remote db on port 3306'
    exit $?
fi

if [[ '${first_server}' =~ 'true' ]]; then
    echo 'Initializing k3s primary server'
    curl -sfL https://get.k3s.io | K3S_CLUSTER_SECRET='${cluster_token}' sh -s - server --datastore-endpoint="mysql://k3s:${sqlpassword}@tcp(externaldb.database.main.oraclevcn.com:3306)/k3sdb"

else
    echo 'Initializing k3s secondary server'
    curl -sfL https://get.k3s.io | K3S_TOKEN='${cluster_token}' sh -s - server --server https://server.public.main.oraclevcn.com:6443
fi

# check tcp to k3s and wait for 10s
nc -vzw20 server.public.main.oraclevcn.com 6443
if [ $? == 0 ] then
    break
else
    echo 'cannot connect to k3s on port 6443'
    exit $?
fi

mkdir /home/opc/.kube
cp /etc/rancher/k3s/k3s.yaml /home/opc/.kube/config
sed -i "s/127.0.0.1/$(hostname -i)/g" /home/opc/.kube/config
chown opc:opc /home/opc/.kube/ -R

export KUBECONFIG=~/.kube/config
iptables -D INPUT -i ens3 -p tcp --dport 6443 -j DROP