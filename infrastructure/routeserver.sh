#!/bin/bash

echo "LOCATION=${LOCATION}"
echo "RG=${RG}"
echo "CSRIPS=${CSRIPS}"
echo "SUBSCRIPTION=${SUBSCRIPTION}"

if [ "$1" == 'create' ]; then

    # apply vnet-peering only after creating of Route Server !!!

    # Create Route Server

    az network public-ip create \
        --resource-group $RG \
        --name RSPIP \
        --version IPv4 \
        --sku Standard \
        --zone 1 2 3

    az network routeserver create --hosted-subnet $SUBSCRIPTION/resourceGroups/$RG/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/RouteServerSubnet \
                                --name RouteServer \
                                --resource-group $RG \
                                --location $LOCATION \
                                --public-ip-address RSPIP

        # apply vnet-peering only after creating of Route Server !!!

    # Create Route Server

    INDEX=0
    for ip in ${CSRIPS} ; do 
        echo $ip,$INDEX
        az network routeserver peering create --name "CSR${INDEX}" \
                                            --peer-asn 65555 \
                                            --peer-ip $ip \
                                            --resource-group $RG \
                                            --routeserver RouteServer 
        INDEX=$(($INDEX + 1))
    done

elif [ "$1" == 'destroy' ]; then
     az network routeserver delete --name RouteServer --resource-group $RG --yes

     az network public-ip delete --name RSPIP --resource-group $RG 
else
    echo "No action ( create or destroy ) specified"
fi

