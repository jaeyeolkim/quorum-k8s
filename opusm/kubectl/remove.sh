#!/bin/bash

for i in {0..5}; do
    if [[ i -eq 5 ]]; then
        RELEASE_NAME="rpc-1"
    else
        RELEASE_NAME="validator-${i}"
    fi

    export GOQOURUM_NODE="goquorum-node-${RELEASE_NAME}"
    envsubst < statefulsets/node-statefulset.yaml | kubectl delete -f -

    echo "✅ $GOQOURUM_NODE deleted successfully."

done