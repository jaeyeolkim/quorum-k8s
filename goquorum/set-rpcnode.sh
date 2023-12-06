#!/bin/bash

PARAM=$1
QUORUM_VALIDATORS="${PARAM:=6}"
for (( i=1; i<=$QUORUM_VALIDATORS; i++ ));
do
  POD_NAME="validator${i}-0"
  echo "======== $POD_NAME ========"

  if [ $QUORUM_RPC_NODE -gt 1 && $i -lt 3 ];then
    if [ $i -eq 1 ];then
      rpcNode=$(kubectl exec $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://localhost:8545)
      rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"
    elif [ $i -eq 2 ];then
      rpcNode=$(kubectl exec -c validator1 $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://localhost:8545)
      rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"
    fi
  fi

  kubectl exec -c validator$i $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":['${rpcNodeAddress}',false],"id":1}' http://localhost:8545
done