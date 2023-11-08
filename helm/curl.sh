index=$1
k get pod goquorum-node-validator-${index}-0 --template '{{.status.podIP}}'
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://$1:8545