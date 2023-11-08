#!/bin/bash

index=$1

function net_peerCount {
  clusterIP=$1
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://${clusterIP}:8545
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://${clusterIP}:8545
}

net_peerCount $(k get svc goquorum-node-validator-${index} -o jsonpath='{.spec.clusterIP}')
