#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    QUORUM_VALIDATORS=5
else
    QUORUM_VALIDATORS=$1
fi
pwd=${PWD}
kubectl apply -f ./namespace/
kubectl apply -f ./secrets/

cd scripts/
bash ./configmap.sh
cd ..
kubectl apply -f ./services/

for (( i=1; i<=$QUORUM_VALIDATORS; i++ ));
do
    sleep 30
    VALIDATOR_NAME="validator${i}"
    echo "======== $VALIDATOR_NAME ========"
    kubectl apply -f ./statefulsets/$VALIDATOR_NAME-statefulset.yaml
done

cd $pwd