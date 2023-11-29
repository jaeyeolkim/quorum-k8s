#!/bin/bash

for i in {1..5}
do
  SVC_NAME="quorum-validator${i}"
  echo "======== $SVC_NAME ========"
  POD_NAME=$1
  kubectl exec $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545
  kubectl exec $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545
done