#!/bin/bash

pwd=${PWD}
kubectl apply -f ./namespace/
kubectl apply -f ./secrets/

cd scripts/
bash ./configmap.sh
cd ..
kubectl apply -f ./services/

for i in {1..5}
do
    sleep 5
    VALIDATOR_NAME="validator${i}"
    echo "======== $VALIDATOR_NAME ========"
    kubectl apply -f ./statefulsets/$VALIDATOR_NAME-statefulset.yaml
done

cd $pwd