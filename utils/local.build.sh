#!/usr/bin/env bash

#Author: <Jason Yin> (jasonyin@live.com)
#File: local.build.sh (c) 2023
#Created: 2023-04-04T20:11:24.848Z

echo "start build"

cd ../terraform

echo "formating code"
terraform fmt -recursive

echo "terraform init"
terraform init

echo "terraform validate"
terraform validate

echo "terraform plan"
terraform plan