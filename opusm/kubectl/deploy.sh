#!/bin/bash

for i in {0..4}; do
    if [[ i -eq 0 ]]; then
        RELEASE_NAME="rpc-$((i+1))"
    else
        RELEASE_NAME="validator-${i}"
    fi
    POD_NAME="goquorum-node-${RELEASE_NAME}-0"

    export GOQOURUM_NODE="goquorum-node-${RELEASE_NAME}"
    export VALIDATOR_NAME="goquorum-node-validator-${i}"
    envsubst < statefulsets/node-statefulset.yaml | kubectl apply -f -

    echo "🚀 Starting installation for ${POD_NAME}..."
    sleep 10  # Give time for the node to start and establish connections

    for j in {1..10}; do
        pod_status=$(k get po $POD_NAME -o jsonpath='{.status.phase}')
        if [[ "$pod_status" == "Running" ]]; then
            echo "✅ $POD_NAME installed successfully."
            break
        else 
            echo "⏳ $POD_NAME status is $pod_status"
            sleep 5
        fi
    done

    echo "----------------------------------------------------------------"

done

sh ./do_rpc_node.sh