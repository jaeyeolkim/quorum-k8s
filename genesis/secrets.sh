#!/bin/bash

mkdir -p build/secrets

for i in {0..4}
do

  nodekey=$(cat build/statefulsets/artifacts/validator$i/nodekey)
  accountkey=$(cat build/statefulsets/artifacts/validator$i/accountKeystore)
  echo "======== build/secrets/validator${i+1}-keys-secret.yaml ========"
cat <<EOF > ./build/secrets/validator${i+1}-keys-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: quorum-validator${i+1}-keys
  labels:
    app: quorum-validator${i+1}-keys
  namespace: quorum
type: Opaque
stringData:
  nodekey: |-
    $nodekey
  accountkey: |-
    $accountkey
  password.txt: |-

EOF

done
