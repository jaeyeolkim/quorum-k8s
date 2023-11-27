#!/bin/bash


for i in {1..5}
do
    echo "======== validator-$i ========"
cat <<EOF > volumes.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: validator$i
  labels:
    app: validator$i
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
  - ./base/statefulsets/validator$i-statefulset.yaml
patches:
  - path: volumes.yaml
EOF

kustomize build > ./build/statefulsets/validator$i-statefulset.yaml

done

