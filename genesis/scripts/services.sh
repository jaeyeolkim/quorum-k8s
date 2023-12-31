#!/bin/bash

mkdir ../services

for (( i=1; i<=$QUORUM_VALIDATORS; i++ ));
do
    echo "======== ../services/validator$i-services.yaml ========"

# validator$i-statefulset.yaml 생성
cat <<EOF >../services/validator$i-services.yaml
apiVersion: v1
kind: Service
metadata:
  name: quorum-validator$i
  labels:
    app: validator$i
  namespace: quorum
spec:
  type: ClusterIP
  selector:
    app: validator$i
  ports:
    - port: 30303
      targetPort: 30303
      protocol: UDP
      name: discovery
    - port: 30303
      targetPort: 30303
      protocol: TCP
      name: rlpx
    - port: 8545
      targetPort: 8545
      protocol: TCP
      name: json-rpc
    - port: 8546
      targetPort: 8546
      protocol: TCP
      name: ws
    - port: 8547
      targetPort: 8547
      protocol: TCP
      name: graphql

EOF

cat ../services/validator$i-services.yaml
done
