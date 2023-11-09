helm uninstall validator-1 validator-2 validator-3 validator-4 validator-5 genesis
k delete rs,deploy,po,job,cm,pv,pvc,secret --all
k delete serviceaccount/nfs-client-provisioner
k delete clusterrole.rbac.authorization.k8s.io/nfs-client-provisioner-runner
k delete clusterrolebinding.rbac.authorization.k8s.io/run-nfs-client-provisioner
k delete role.rbac.authorization.k8s.io/leader-locking-nfs-client-provisioner
k delete rolebinding.rbac.authorization.k8s.io/leader-locking-nfs-client-provisioner
k delete ns quorum
sudo rm -rf /mnt/shared/*