kubectl delete -f statefulsets/
#kubectl delete -f deployments/
kubectl delete -f secrets/
kubectl delete configmap --all -n quorum
kubectl delete -f services/
kubectl delete -f namespace/