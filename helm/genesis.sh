k create ns quorum
k apply -f ../nfs/rbac.yml
k apply -f ../nfs/deployment.yml
k apply -f ../nfs/storage.yml
k apply -f ../nfs/pvc.yml
# helm install genesis ./charts/goquorum-genesis --namespace quorum --create-namespace --values ./values/genesis-goquorum.yml
