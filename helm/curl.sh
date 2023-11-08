#!/bin/bash

index=$1

function net_peerCount {
  clusterIP=$1
  echo ${clusterIP}
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://${clusterIP}:8545
}

net_peerCount $(k get svc goquorum-node-validator-${index} -o jsonpath='{.spec.clusterIP}')
