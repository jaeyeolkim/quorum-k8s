helm install validator-1 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
sleep 3
helm install validator-2 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
sleep 3
helm install validator-3 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
sleep 3
helm install validator-4 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml
sleep 3
helm install validator-5 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml