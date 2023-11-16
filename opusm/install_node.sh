#!/bin/bash

for i in {1..5}; do
  RELEASE_NAME="validator-${i}"
  helm install $RELEASE_NAME ./helm/charts/goquorum-node --namespace quorum --values ./helm/values/validator.yaml
  sleep 5
done
