#!/bin/bash

kubectl create ns quorum
kubectl apply -f ../nfs/rbac.yml
kubectl apply -f ../nfs/deployment.yml
kubectl apply -f ../nfs/storage.yml
kubectl apply -f ../nfs/pvc.yml

helm install genesis ./helm/charts/goquorum-genesis --namespace quorum --create-namespace --values ./helm/values/genesis-goquorum.yaml

for i in {1..5}; do
  RELEASE_NAME="validator-${i}"
  helm install $RELEASE_NAME ./helm/charts/goquorum-node --namespace quorum --values ./helm/values/validator.yaml
  sleep 5
done

# for i in {0..4}; do
#   if [[ i -eq 0 ]]; then
#     RELEASE_NAME="rpc-$((i+1))"
#   else
#     RELEASE_NAME="validator-${i}"
#   fi

#   helm install $RELEASE_NAME ./charts/goquorum-node --namespace quorum --values ./values/validator.yaml
#   sleep 2
  
# done