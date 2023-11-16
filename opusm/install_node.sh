#!/bin/bash

# for i in {1..5}; do
#   RELEASE_NAME="validator-${i}"
#   helm install $RELEASE_NAME ./helm/charts/goquorum-node --namespace quorum --values ./helm/values/validator.yaml
#   sleep 5
# done

for i in {1..5}; do
  if [[ i -eq 5 ]]; then
    RELEASE_NAME="rpc-1"
  else
    RELEASE_NAME="validator-${i}"
  fi

  helm install $RELEASE_NAME ./charts/goquorum-node --namespace quorum --values ./values/validator.yaml
  sleep 5
  
done