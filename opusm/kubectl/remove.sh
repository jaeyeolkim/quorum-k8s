
for i in {0..4}; do
    if [[ i -eq 0 ]]; then
        RELEASE_NAME="rpc-$((i+1))"
    else
        RELEASE_NAME="validator-${i}"
    fi

    export GOQOURUM_NODE="goquorum-node-${RELEASE_NAME}"
    envsubst < statefulsets/node-statefulset.yaml | kubectl delete -f -

    echo "✅ $GOQOURUM_NODE deleted successfully."

done