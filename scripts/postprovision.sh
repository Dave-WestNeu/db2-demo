#!/bin/bash

# safe bash boilerplate
set -euo pipefail

kubectl apply -f manifests/db2.yaml
kubectl apply -f manifests/db2-service.yaml