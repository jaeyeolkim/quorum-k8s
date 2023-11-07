k apply -f ../nfs/rbac.yml
k apply -f ../nfs/deployment.yml
k apply -f ../nfs/storage.yml
k apply -f ../nfs/pvc.yml
helm install genesis ./charts/goquorum-genesis --namespace quorum --create-namespace --values ./values/genesis-goquorum.yml
helm install validator-1 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
helm install validator-2 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
helm install validator-3 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
helm install validator-4 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
