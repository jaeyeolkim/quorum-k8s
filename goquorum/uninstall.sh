#!/bin/bash

helm uninstall genesis

# for i in {1..5}; do
#   RELEASE_NAME="validator-${i}"
#   helm uninstall $RELEASE_NAME
# done

kubectl delete rs,deploy,po,job,cm,pv,pvc,secret --all
kubectl delete serviceaccount/nfs-client-provisioner
kubectl delete clusterrole.rbac.authorization.k8s.io/nfs-client-provisioner-runner
kubectl delete clusterrolebinding.rbac.authorization.k8s.io/run-nfs-client-provisioner
kubectl delete role.rbac.authorization.k8s.io/leader-locking-nfs-client-provisioner
kubectl delete rolebinding.rbac.authorization.k8s.io/leader-locking-nfs-client-provisioner
kubectl delete ns quorum
sudo rm -rf /mnt/shared/*