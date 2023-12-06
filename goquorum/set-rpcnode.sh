#!/bin/bash

ARGS1=$1
ARGS2=$2
QUORUM_VALIDATORS="${ARGS1:=6}"
QUORUM_RPC_NODE="${ARGS2:=2}"
RPC_POD_NAME="validator1-0"
for (( i=1; i<=$QUORUM_VALIDATORS; i++ ));
do
  POD_NAME="validator${i}-0"
  echo "======== $POD_NAME ========"

  rpcNode=$(kubectl exec -c validator1 $RPC_POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://localhost:8545)
  rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"
  kubectl exec -c validator$i $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":['${rpcNodeAddress}',false],"id":1}' http://localhost:8545

  if [ $QUORUM_RPC_NODE -gt 1 ] && [ $i -lt 3 ];then
    RPC_POD_NAME="validator2-0"
    rpcNode=$(kubectl exec -c validator2 $RPC_POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://localhost:8545)
    rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"
    kubectl exec -c validator$i $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":['${rpcNodeAddress}',false],"id":1}' http://localhost:8545
  fi
  
done