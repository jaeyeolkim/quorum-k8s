#!/bin/bash

rpcNodeIP=$(k get svc quorum-validator1 -o jsonpath='{.spec.clusterIP}')
rpcNode=$(curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://${rpcNodeIP}:8545)
rpcNodeAddress="$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')"

function geth_method {
  clusterIP=$1
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":[""$rpcNodeAddress"",false],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_isValidator","params":[],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://${clusterIP}:8545
}

for i in {1..5}
do
    echo "======== validator-$i ========"
    geth_method $(k get svc quorum-validator${i} -o jsonpath='{.spec.clusterIP}')
done