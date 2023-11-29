#!/bin/bash

cd ./artifacts/goQuorum

# static-nodes.json, permissioned-nodes.json <HOST> replace
for i in {1..5}
do
  sed -i "$((i+1))s/<HOST>/validator$i-0.quorum-validator$i.quorum.svc.cluster.local/gi" static-nodes.json
  sed -i "$((i+1))s/<HOST>/validator$i-0.quorum-validator$i.quorum.svc.cluster.local/gi" permissioned-nodes.json
done

kubectl create configmap goquorum-genesis-configmap --from-file=genesis.json -n quorum
kubectl create configmap quorum-static-nodes-configmap --from-file=static-nodes.json -n quorum
kubectl create configmap quorum-permissions-nodes-configmap --from-file=permissioned-nodes.json -n quorum

kubectl label configmaps goquorum-genesis-configmap app=goquorum-genesis-configmap -n quorum
kubectl label configmaps quorum-static-nodes-configmap app=quorum-static-nodes-configmap -n quorum
kubectl label configmaps quorum-permissions-nodes-configmap app=quorum-permissions-nodes-configmap -n quorum
