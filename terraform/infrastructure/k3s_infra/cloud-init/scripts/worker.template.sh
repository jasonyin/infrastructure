#!/bin/bash

systemctl disable firewalld --now

# check tcp to k3s and wait for 10s
while ! nc -vzw20 server.public.main.oraclevcn.com 6443; do
  sleep 5
  echo 'sleep 5'
done

curl -sfL https://get.k3s.io | K3S_URL=https://server.public.main.oraclevcn.com:6443 K3S_TOKEN='${cluster_token}' sh -

echo 'k3s worker node installed!!!!'