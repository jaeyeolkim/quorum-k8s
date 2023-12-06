#!/bin/bash

mkdir ../namespace

cat <<EOF >../namespace/quorum-namespace.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: quorum

EOF

cat ../namespace/quorum-namespace.yaml