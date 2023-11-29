kubectl apply -f ./namespace/
kubectl apply -f ./secrets/
# kubectl apply -f ./configmap/
kubectl apply -f ./services/
# kubectl apply -f ./deployments/

for i in {1..5}
do
    sleep 5
    VALIDATOR_NAME="validator${i}"
    echo "======== $VALIDATOR_NAME ========"
    kubectl apply -f ./statefulsets/$VALIDATOR_NAME-statefulset.yaml
done