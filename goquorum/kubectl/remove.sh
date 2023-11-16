#!/bin/bash

for i in {1..5}; do
    RELEASE_NAME="validator-${i}"
    export GOQOURUM_NODE="goquorum-node-${RELEASE_NAME}"
    envsubst < statefulsets/node-statefulset.yaml | kubectl delete -f -

    echo "✅ $GOQOURUM_NODE deleted successfully."

done