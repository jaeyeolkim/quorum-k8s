#!/bin/bash

function geth_method {
  clusterIP=$1
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_isValidator","params":[],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://${clusterIP}:8545
}

for i in {1..5}
do
    SVC_NAME="goquorum-node-validator-${i}"
    echo "======== $SVC_NAME ========"
    geth_method $(k get svc $SVC_NAME -o jsonpath='{.spec.clusterIP}')
done

curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_getValidators","params":[],"id":1}' http://${clusterIP}:8545