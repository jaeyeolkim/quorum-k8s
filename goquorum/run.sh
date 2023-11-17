#!/bin/bash

for i in {1..5}; do
    # if [[ i -eq 5 ]]; then
    #     RELEASE_NAME="rpc-1"
    # else
    #     RELEASE_NAME="validator-${i}"
    # fi
    echo "🚀 Starting installation for ${POD_NAME}..."
    RELEASE_NAME="validator-${i}"
    POD_NAME="goquorum-node-${RELEASE_NAME}-0"

    export METADATA_NAME="goquorum-node-${RELEASE_NAME}"
    # export VALIDATOR_NAME="goquorum-node-validator-$i"
    envsubst < ./kubectl/services/node-storage.yaml | kubectl apply -f -
    envsubst < ./kubectl/services/node-service.yaml | kubectl apply -f -
    envsubst < ./kubectl/services/node-service-account.yaml | kubectl apply -f -
    sleep 3
    envsubst < ./kubectl/statefulsets/node-statefulset.yaml | kubectl apply -f -

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

    echo "-----------------------------------------------------------"

done

echo "✏️  Propose 'goquorum-node-validator-1' node as false"
rpcNodeIP=$(k get svc goquorum-node-validator-1 -o jsonpath='{.spec.clusterIP}')
rpcNode=$(curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://${rpcNodeIP}:8545)
rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"
echo "rpcNodeAddress: $rpcNodeAddress"

function geth_method {
  clusterIP=$1
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":['${rpcNodeAddress}',false],"id":1}' http://${clusterIP}:8545
}


for j in {1..5}
do
    SVC_NAME="goquorum-node-validator-${j}"
    echo "======== $SVC_NAME ========"
    geth_method $(k get svc $SVC_NAME -o jsonpath='{.spec.clusterIP}')
done

curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_getValidators","params":[],"id":1}' http://${clusterIP}:8545
