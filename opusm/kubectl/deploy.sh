#!/bin/bash

for i in {0..4}; do
    if [[ i -eq 0 ]]; then
        RELEASE_NAME="rpc-$((i+1))"
    else
        RELEASE_NAME="validator-${i}"
    fi
    POD_NAME="goquorum-node-$RELEASE_NAME"

    export GOQOURUM_NODE=POD_NAME
    kubectl apply -f statefulsets/

    echo "🚀 Starting installation for ${POD_NAME}..."
    sleep 10  # Give time for the node to start and establish connections

    for j in {1..10}; do
        isRunning=$(k get po $POD_NAME -o jsonpath='{.status.phase}')
        if [[ "$isRunning" == "Running" ]]; then
        echo "$POD_NAME is Running"
            break
        else 
            sleep 5
        fi
    done

    echo "✅ $POD_NAME installed successfully."

done

sh ./do_rpc_node.sh