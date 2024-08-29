#!/bin/bash

# safe bash boilerplate
set -euo pipefail

echo "please log in to az"
az login

echo "installing aks cli, kubectl, etc"
az aks install-cli

echo "getting aks credentials"
az aks get-credentials --resource-group rg-openaistudio-demo-01 --name db2-test

sleep 3

kubectl delete -f manifests/db2.yaml || true
kubectl apply -f manifests/db2.yaml
kubectl apply -f manifests/db2-service.yaml

# wait 6 min show dots and tell the user with a nice progress bar
# skip a line every 10 dots
echo "Waiting 6 min for DB2 to start (1 dot = 10s)"
for i in {1..36}; do
  echo -n "."
  if [ $((i % 6)) -eq 0 ]; then
    echo
  fi
  sleep 10
done

# show IP address of the DB2 service
echo "DB2 IP address:"
kubectl get svc db2-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}'

echo "DB2 Port:"
echo "50000"

echo "DB2 Username:"
echo "db2inst1"

echo "DB2 Password:"
echo "your_password"

echo "DBNAME:"
echo "sample"

echo "DB2 Instance Name:"
echo "db2inst1"