#!/bin/bash

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
            path: $PWD/../../artifacts/goQuorum/genesis.json
            type: File
        - name: static-nodes-file
          hostPath:
            path: $PWD/../../artifacts/goQuorum/static-nodes.json
            type: File
        - name: permissions-nodes-config
          hostPath:
            path: $PWD/../../artifacts/goQuorum
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