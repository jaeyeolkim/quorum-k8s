#!/bin/bash

kubectl create ns quorum
kubectl apply -f ../nfs/rbac.yml
kubectl apply -f ../nfs/deployment.yml
kubectl apply -f ../nfs/storage.yml
kubectl apply -f ../nfs/pvc.yml

helm install genesis ./helm/charts/goquorum-genesis --namespace quorum --create-namespace --values ./helm/values/genesis-goquorum.yaml
