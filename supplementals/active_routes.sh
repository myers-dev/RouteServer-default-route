#!/bin/bash

if [ "$#" != 2 ]; then
    echo "Syntax: $0 vm-name rg-name"
    exit 1
fi
vmname=$1
rgname=$2

id=`az vm show --name "${vmname}" --resource-group "${rgname}" --query "networkProfile.networkInterfaces[0].id" | tr -d "\""`

az network nic show-effective-route-table --ids $id -o table