#!/bin/bash

bash ./quorum-genesis.sh
bash ./namespace.sh
bash ./configmap.sh
bash ./secrets.sh
bash ./statefulsets.sh
