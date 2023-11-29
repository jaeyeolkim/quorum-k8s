#!/bin/bash

pwd=${PWD}

rm -rf artifacts/
rm -rf namespace/
rm -rf secrets/
rm -rf services/
rm -rf statefulsets/

# genesis quorum
npx quorum-genesis-tool --consensus qbft --validators 5 --chainID 1337 --blockperiod 1 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --members 0 --bootnodes 0 --outputPath 'artifacts'

yyyy=$(date '+%Y')
mv artifacts/$yyyy-*/* artifacts
rm -rf artifacts/$yyyy-*

# create manifest 
cd scripts/
bash ./namespace.sh
bash ./configmap.sh
bash ./secrets.sh
bash ./services.sh
bash ./statefulsets.sh

cd $pwd
