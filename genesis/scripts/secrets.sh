#!/bin/bash

mkdir ../secrets

validators_index=$((QUORUM_VALIDATORS-1))
for (( i=0; i<=$validators_index; i++ ));
do
  num=$((i+1))
  nodekey=$(cat ../artifacts/validator${i}/nodekey)
  accountkey=$(cat ../artifacts/validator${i}/accountKeystore)
  echo "======== ../secrets/validator${num}-keys-secret.yaml ========"
cat <<EOF > ../secrets/validator${num}-keys-secret.yaml
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

cat ../secrets/validator${num}-keys-secret.yaml

done
