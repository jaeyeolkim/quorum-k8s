
for i in {0..4}; do
    if [[ i -eq 0 ]]; then
        RELEASE_NAME="rpc-$((i+1))"
    else
        RELEASE_NAME="validator-${i}"
    fi
    POD_NAME="goquorum-node-$RELEASE_NAME"

    export GOQOURUM_NODE=POD_NAME
    kubectl delete -f statefulsets/

    echo "✅ $POD_NAME deleted successfully."

done