# scp -i ~/.ssh/lightsail_ubuntu1.pem ubuntu@13.125.35.215:/home/ubuntu/quorum-k8s/helm/genesis.yaml workspace/opusm/quorum-k8s/helm/debug
# scp -i ~/.ssh/lightsail_ubuntu1.pem ubuntu@13.125.35.215:/home/ubuntu/quorum-k8s/helm/validator1.yaml workspace/opusm/quorum-k8s/helm/debug
helm install genesis ./charts/goquorum-genesis --namespace quorum --create-namespace --values ./values/genesis-goquorum.yml --dry-run --debug > genesis.yaml
helm install validator-1 ./charts/goquorum-node --namespace quorum --values ./values/validator.yml --dry-run --debug > validator1.yaml