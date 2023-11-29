#!/bin/bash

kubectl delete ns quorum

bash ./quorum-genesis.sh
bash ./namespace.sh
bash ./configmap.sh
bash ./secrets.sh
bash ./services.sh
bash ./statefulsets.sh
