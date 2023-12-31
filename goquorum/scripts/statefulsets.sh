#!/bin/bash

if [ "$QUORUM_CONSENSUS" == "ibft" ];then 
  QUORUM_CONSENSUS_VALUE="istanbul"
else
  QUORUM_CONSENSUS_VALUE="$QUORUM_CONSENSUS"
fi

mkdir ../statefulsets

for (( i=1; i<=$QUORUM_VALIDATORS; i++ ));
do
    echo "======== ../statefulsets/validator$i-statefulset.yaml ========"

# validator$i-statefulset.yaml 생성
cat <<EOF >../statefulsets/validator$i-statefulset.yaml
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

EOF


cat <<EOF >>../statefulsets/validator$i-statefulset.yaml
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: validator$i
  namespace: quorum
  labels:
    app: validator$i
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
        tier: backend
EOF

if [ $QUORUM_RPC_NODE -gt 1 ] && [ $i -lt 3 ];then
# quorum-rpcnode 서비스와 멀티 매핑
cat <<EOF >>../statefulsets/validator$i-statefulset.yaml
        component: quorum-rpcnode
EOF
fi

cat <<EOF >>../statefulsets/validator$i-statefulset.yaml
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9545"
        prometheus.io/path: "/debug/metrics/prometheus"
    spec:
      serviceAccountName: validator$i-sa
EOF

if [ $i -gt 1 ];then
cat <<EOF >>../statefulsets/validator$i-statefulset.yaml
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

for (( k=2; k<=$i; k++ ));
do
cat <<EOF >>../statefulsets/validator$i-statefulset.yaml
              curl -X GET --connect-timeout 30 --max-time 10 --retry 6 --retry-delay 0 --retry-max-time 300 http://quorum-validator$((k-1)).quorum.svc.cluster.local:8545
              sleep 30
EOF
done
fi

cat <<EOF >>../statefulsets/validator$i-statefulset.yaml
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
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: QUORUM_NETWORK_ID
              value: "${QUORUM_NETWORK_ID}"
            - name: QUORUM_CONSENSUS
              value: ${QUORUM_CONSENSUS_VALUE}
            - name: PRIVATE_CONFIG
              value: ignore
          volumeMounts:
            - name: keys
              mountPath: /config/keys/
              readOnly: true
            - name: static-nodes-file
              mountPath: /config/static-nodes
              readOnly: true
            - name: permissions-nodes-config
              mountPath: /config/permissions-nodes/
              readOnly: true
            - name: genesis-file
              mountPath: /config/quorum/
              readOnly: true
            - name: data
              mountPath: /data
          ports:
            - containerPort: 8545
              name: json-rpc
              protocol: TCP
            - containerPort: 8546
              name: ws
              protocol: TCP
            - containerPort: 8547
              name: graphql
              protocol: TCP
            - containerPort: 30303
              name: rlpx
              protocol: TCP
            - containerPort: 30303
              name: discovery
              protocol: UDP
            - containerPort: 9545
              name: metrics
              protocol: TCP
          command:
            - /bin/sh
            - -c
          args:
            - "exec \n
              cp /config/static-nodes/static-nodes.json /data/\n
              cp /config/permissions-nodes/*.json /data/\n
              cp /config/quorum/genesis.json /data/\n
              geth --datadir=/data init /config/quorum/genesis.json\n
              cp /config/keys/accountkey /data/keystore/key\n
              cp /config/keys/nodekey /data/geth/nodekey\n
              \n
              geth \
              --datadir /data \
              --nodiscover \
              --nat=any \
              --permissioned --emitcheckpoints --verbosity 5 \
              --istanbul.blockperiod 1 --mine --miner.threads 1 \
              --syncmode full \
              --networkid ${QUORUM_NETWORK_ID} \
              --http --http.addr 0.0.0.0 --http.port 8545 --http.corsdomain \"*\" --http.vhosts \"*\"  \
              --http.api admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
              --ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins \"*\" \
              --ws.api admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
              --port 30303 \
              --unlock 0  \
              --allow-insecure-unlock  \
              --metrics --pprof --pprof.addr 0.0.0.0 --pprof.port 9545 \
              --password /config/keys/password.txt\n"
          livenessProbe:
            httpGet:
              path: /
              port: 8545
            initialDelaySeconds: 120
            periodSeconds: 30
      volumes:
        - name: keys
          secret:
            secretName: quorum-validator$i-keys
        - name: genesis-file
          configMap:
            name: goquorum-genesis-configmap
            items:
              - key: genesis.json
                path: genesis.json
        - name: static-nodes-file
          configMap:
            name: quorum-static-nodes-configmap
            items:
              - key: static-nodes.json
                path: static-nodes.json
        - name: permissions-nodes-config
          configMap:
            name: quorum-permissions-nodes-configmap
EOF

done
