kubectl delete -f statefulsets/
#kubectl delete -f deployments/
kubectl delete -f secrets/
kubectl delete configmap goquorum-genesis-configmap -n quorum
kubectl delete configmap quorum-permissions-nodes-configmap -n quorum
kubectl delete configmap quorum-static-nodes-configmap -n quorum
kubectl delete pv,pvc --all -n quorum
kubectl delete -f services/
kubectl delete -f namespace/