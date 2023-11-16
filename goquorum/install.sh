#!/bin/bash

kubectl create ns quorum
kubectl apply -f ../nfs/rbac.yml
kubectl apply -f ../nfs/deployment.yml
kubectl apply -f ../nfs/storage.yml
kubectl apply -f ../nfs/pvc.yml

echo "🚀 Install helm goquorum-genesis charts..."
helm install genesis ./helm/charts/goquorum-genesis --namespace quorum --create-namespace --values ./helm/values/genesis-goquorum.yaml

sleep 10

for i in {1..20}; do
    job_status=$(k get job goquorum-genesis-init -o jsonpath='{.status.ready}')
    if [[ $job_status -eq 0 ]]; then
        echo "✅ Genesis Job successfully Completed!"
        break
    else 
        echo "⏳ Waiting for Genesis job to completed..."
        sleep 5
    fi
done

echo "🚀 Install helm goquorum-node charts..."
for j in {1..5}; do
  sleep 5
  RELEASE_NAME="validator-$j"
  helm install $RELEASE_NAME ./helm/charts/goquorum-node --namespace quorum --values ./helm/values/validator.yaml
done
