kubectl apply -f build/namespace/
kubectl apply -f build/secrets/
# kubectl apply -f build/configmap/
kubectl apply -f build/services/
# kubectl apply -f build/deployments/

for i in {1..5}
do
    sleep 10
    VALIDATOR_NAME="validator${i}"
    echo "======== $VALIDATOR_NAME ========"
    kubectl apply -f build/statefulsets/$VALIDATOR_NAME-statefulset.yaml
done