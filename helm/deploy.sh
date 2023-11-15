#!/bin/bash

helm install genesis ./charts/goquorum-genesis --namespace quorum --create-namespace --values ./values/genesis-goquorum.yml
echo "⏳ Waiting for genesis to be installed..."
sleep 30

for i in {0..4}; do
  if [[ i -eq 0 ]]; then
    RELEASE_NAME="rpc-$((i+1))"
  else
    RELEASE_NAME="validator-${i}"
  fi
  POD_NAME="goquorum-node-$RELEASE_NAME-0"
  EXPECTED_PEERS_HEX=$(printf "0x%x" $i)
  INSTALL_SUCCESS=false
  RETRY_COUNT=0

  echo "🚀 Starting installation for ${POD_NAME}..."
  while [ "$INSTALL_SUCCESS" != true ]; do
    if [ $RETRY_COUNT -ge 3 ]; then
      echo "❌ Failed to install $RELEASE_NAME after 3 attempts. Deleting namespace and exiting..."
      kubectl delete ns quorum
      exit 1
    fi

    helm install $RELEASE_NAME ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
    echo "⏳ Waiting for $POD_NAME to start..."
    sleep 30  # Give time for the node to start and establish connections

    for j in {1..5}; do
        isRunning=$(k get po $POD_NAME -o jsonpath='{.status.phase}')
        if [[ "$isRunning" == "Running" ]]; then
	    echo "$POD_NAME is Running"
            break
        else 
            sleep 10
        fi
    done

    echo "🔍 Accessing $POD_NAME..."
    result=$(kubectl exec $POD_NAME -- curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545)
    echo "📑 Result from $POD_NAME: $result"

    if [[ "$result" == *"$EXPECTED_PEERS_HEX"* ]]; then
      echo "✅ $RELEASE_NAME has the expected peer count: $EXPECTED_PEERS_HEX."
      INSTALL_SUCCESS=true
    else
      echo "🔄 $RELEASE_NAME has an unexpected peer count. Expected: $EXPECTED_PEERS_HEX. Reinstalling..."
      helm uninstall $RELEASE_NAME
      echo "⏳ Waiting for uninstallation to complete..."
      sleep 10  # Wait for the uninstall to complete
      RETRY_COUNT=$((RETRY_COUNT+1))
    fi
  done

  echo "✅ $RELEASE_NAME installed successfully with the expected peer count."
  echo "===================================================================="
done

echo "🎉 All nodes have been installed successfully."