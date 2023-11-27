#!/bin/bash

# genesis quorum
npx quorum-genesis-tool --consensus qbft --validators 5 --chainID 1337 --blockperiod 1 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --members 0 --bootnodes 0 --outputPath 'artifacts'

yyyy=$(date '+%Y')
mv artifacts/$yyyy-*/* artifacts
rm -rf artifacts/$yyyy-*

# build
mkdir -p ./build/statefulsets
kustomize build > ./build/statefulsets/validator1-statefulset.yaml


cat <<EOF > volumes.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: validator1
  labels:
    app: validator1
  namespace: quorum
spec:
  template:
    spec:
      volumes:
        - name: genesis-file
          hostPath:
            path: ./artifacts/goQuorum/genesis.json
            type: File
        - name: static-nodes-file
          hostPath:
            path: ./artifacts/goQuorum/static-nodes.json
            type: File
        - name: permissions-nodes-config
          hostPath:
            path: ./artifacts/goQuorum
            type: Directory
EOF

# kustomization.yaml 생성
cat <<EOF >./kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ./base/statefulsets/validator1-statefulset.yaml
patches:
  - path: volumes.yaml
EOF