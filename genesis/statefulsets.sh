#!/bin/bash

mkdir -p build/statefulsets

for i in {1..5}
do
    echo "======== build/statefulsets/validator$i-statefulset.yaml ========"

cat <<EOF > statefulset.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: validator$i-sa
  namespace: quorum

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: validator$i-keys-read-role
  namespace: quorum
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    resourceNames: ["quorum-validator$i-keys"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["services"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: validator$i-rb
  namespace: quorum
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: validator$i-keys-read-role
subjects:
  - kind: ServiceAccount
    name: validator$i-sa
    namespace: quorum

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: validator$i
  labels:
    app: validator$i
  namespace: quorum
spec:
  replicas: 1
  selector:
    matchLabels:
      app: validator$i
  serviceName: quorum-validator$i
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        storageClassName: nfs-client
        accessModes:
          - ReadWriteMany
        resources:
          requests:
            storage: "20Gi"
  template:
    metadata:
      labels:
        app: validator$i
    spec:
      serviceAccountName: validator$i-sa
EOF

if [ i -gt 1 ];then
cat <<EOF >> statefulset.yaml

      initContainers:
        - name: init-bootnode
          image: curlimages/curl:7.79.1
          command:
            - /bin/sh
            - -c
          args:
            - |
              exec 

EOF

for j in {1..5}
do
	for (( k=2; k<=$j; k++ ));
    do
cat <<EOF >> statefulset.yaml
              curl -X GET --connect-timeout 30 --max-time 10 --retry 6 --retry-delay 0 --retry-max-time 300 http://quorum-validator$((k-1)).quorum.svc.cluster.local:8545
              sleep 30
EOF
	done
done

cat <<EOF >> statefulset.yaml
      containers:
        - name: validator$i
          image: quorumengineering/quorum:latest
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              cpu: 100m
              memory: 1024Mi
            limits:
              cpu: 500m
              memory: 2048Mi
          env:
            - name: QUORUM_NETWORK_ID
              value: "1337"
            - name: QUORUM_CONSENSUS
              value: qbft
      volumes:
        - name: keys
          secret:
            secretName: quorum-validator$i-keys
EOF

# kustomization.yaml 생성
cat <<EOF >./kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ./base/statefulsets/validator1-statefulset.yaml
patches:
  - path: statefulset.yaml
EOF

kustomize build > ./build/statefulsets/validator$i-statefulset.yaml

done
