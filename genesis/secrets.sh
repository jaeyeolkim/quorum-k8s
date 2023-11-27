#!/bin/bash

mkdir -p build/secrets

for i in {1..5}
do

  nodekey=$(cat build/statefulsets/artifacts/validator${i-1}/nodekey)
  accountkey=$(cat build/statefulsets/artifacts/validator${i-1}/accountKeystore)
  echo "======== build/secrets/validator$i-keys-secret.yaml ========"
cat <<EOF > ./build/secrets/validator$i-keys-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: quorum-validator$i-keys
  labels:
    app: quorum-validator$i-keys
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
