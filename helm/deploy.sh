#!/bin/bash

helm install genesis ./charts/goquorum-genesis --namespace quorum --create-namespace --values ./values/genesis-goquorum.yml
echo "⏳ Waiting for genesis to be installed..."
sleep 30

for i in {1..5}; do
  POD_NAME="goquorum-node-validator-${i}-0"
  EXPECTED_PEERS_HEX=$(printf "0x%x" $((i-1)))
  INSTALL_SUCCESS=false
  RETRY_COUNT=0

  echo "🚀 Starting installation for validator $i..."
  while [ "$INSTALL_SUCCESS" != true ]; do
    if [ $RETRY_COUNT -ge 3 ]; then
      echo "❌ Failed to install validator $i after 3 attempts. Deleting namespace and exiting..."
      kubectl delete ns quorum
      exit 1
    fi

    helm install "validator-$i" ./charts/goquorum-node --namespace quorum --values ./values/validator.yml

    echo "⏳ Waiting for $POD_NAME to start..."
    sleep 30  # Give time for the node to start and establish connections

    echo "🔍 Accessing $POD_NAME..."
    result=$(kubectl exec $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545)
    echo "📑 Result from $POD_NAME: $result"

    if [[ "$result" == *"$EXPECTED_PEERS_HEX"* ]]; then
      echo "✅ Validator $i has the expected peer count: $EXPECTED_PEERS_HEX."
      INSTALL_SUCCESS=true
    else
      echo "🔄 Validator $i has an unexpected peer count. Expected: $EXPECTED_PEERS_HEX. Reinstalling..."
      helm uninstall "validator-$i"
      echo "⏳ Waiting for uninstallation to complete..."
      sleep 10  # Wait for the uninstall to complete
      RETRY_COUNT=$((RETRY_COUNT+1))
    fi
  done

  echo "✅ Validator $i installed successfully with the expected peer count."
done

echo "🎉 All nodes have been installed successfully."