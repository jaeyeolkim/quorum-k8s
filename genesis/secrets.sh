#!/bin/bash

mkdir -p build/secrets

for i in {0..4}
do
  num=$((i+1))
  nodekey=$(cat build/statefulsets/artifacts/validator${i}/nodekey)
  accountkey=$(cat build/statefulsets/artifacts/validator${i}/accountKeystore)
  echo "======== build/secrets/validator${num}-keys-secret.yaml ========"
cat <<EOF > ./build/secrets/validator${num}-keys-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: quorum-validator${num}-keys
  labels:
    app: quorum-validator${num}-keys
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
