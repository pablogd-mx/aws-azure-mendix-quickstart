#!/bin/bash
# Usage:
# do-all.sh connected
# do-all.sh standalone
#
#
 chmod +x *.sh
 mode=get-mode.sh

echo "Type cluster provider : eks (AWS) or aks (Azure)"
read cluster
if [[ "$cluster" == "eks" ]]
then
#Sets the Environment variables
    echo "Creating Cluster in AWS EKS, grab a coffee this will take a while"
. ./env.sh
### Create a cluster 
. ./create-cluster.sh
elif [[ "$cluster" == "aks" ]]
then
    echo echo "Creating Cluster in Azure AKS, grab a coffee this will take a while"
#Sets the Environment variables
. ./env-aks.sh
### Create a cluster 
. ./create-aks-cluster.sh
else
    echo "Please type eks or aks"
    exit 1;
fi
### Install nginx
. ./install-nginx-ingress.sh
sleep 20

### Install Prometheus
install-grafana-prometheus.sh

sleep 40


echo "$0: First parameter  is : " $1

### Configure namespace for Mendix runtime
. ./configure.sh mode


### Deploy the application
kubectl apply -f demo.yaml

validate.sh

