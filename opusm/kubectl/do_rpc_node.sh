#!/bin/bash

rpcNodeIP=$(k get svc goquorum-node-validator-1 -o jsonpath='{.spec.clusterIP}')
rpcNode=$(curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://${rpcNodeIP}:8545)
rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"
echo "rpcNodeAddress: $rpcNodeAddress"

function geth_method {
  clusterIP=$1
  curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":['${rpcNodeAddress}',false],"id":1}' http://${clusterIP}:8545
}


for i in {1..5}
do
    SVC_NAME="goquorum-node-validator-${i}"
    echo "======== $SVC_NAME ========"
    geth_method $(k get svc $SVC_NAME -o jsonpath='{.spec.clusterIP}')
done

curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_getValidators","params":[],"id":1}' http://${clusterIP}:8545


# rpcNodeIP=$(k get svc goquorum-node-rpc-1 -o jsonpath='{.spec.clusterIP}')
# rpcNode=$(curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_nodeAddress","params":[],"id":1}' http://${rpcNodeIP}:8545)
# rpcNodeAddress=\"$(echo $rpcNode | grep -Po '(?<="result":")[^"]+')\"

# function geth_method {
#   clusterIP=$1
#   curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_propose","params":['${rpcNodeAddress}',false],"id":1}' http://${clusterIP}:8545
# }


# for i in {0..4}
# do
#   if [[ i -eq 0 ]]; then
#       SVC_NAME="goquorum-node-rpc-${i+1}"
#   else
#       SVC_NAME="goquorum-node-validator-${i}"
#   fi
#     echo "======== $SVC_NAME ========"
#     geth_method $(k get svc $SVC_NAME -o jsonpath='{.spec.clusterIP}')
# done

# curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"istanbul_getValidators","params":[],"id":1}' http://${clusterIP}:8545