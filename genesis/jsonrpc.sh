#!/bin/bash

QUORUM_VALIDATORS="${$1:=5}"
for (( i=1; i<=$QUORUM_VALIDATORS; i++ ));
do
  POD_NAME="validator${i}-0"
  echo "======== $POD_NAME ========"
  kubectl exec -c validator$i $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545
  kubectl exec -c validator$i $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545
done