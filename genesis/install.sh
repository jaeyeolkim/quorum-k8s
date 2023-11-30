#!/bin/bash

echo "================================"
echo "🎉 Welcome to the Quorum"
echo "================================"
echo "Please select the options required for installation"
echo -n "1. Consensus? [1.qbft(default), 2.ibft]"
read -r QUORUM_CONSENSUS
QUORUM_CONSENSUS="${QUORUM_CONSENSUS:=qbft}"

echo -n "2. Validators? [4, 5(default), 6, 7]"
read -r QUORUM_VALIDATORS
QUORUM_VALIDATORS="${QUORUM_VALIDATORS:=4}"

echo -n "3. ChainID? [1337(default), ...]"
read -r QUORUM_NETWORK_ID
QUORUM_NETWORK_ID="${QUORUM_NETWORK_ID:=1337}"

echo -n "4. Blockperiod? [1(default), ...]"
read -r QUORUM_BLOCKPERIOD
QUORUM_BLOCKPERIOD="${QUORUM_BLOCKPERIOD:=1}"

echo "Please check the option you have chosen"
echo "--consensus: $QUORUM_CONSENSUS"
echo "--validators: $QUORUM_VALIDATORS"
echo "--chainID: $QUORUM_NETWORK_ID"
echo "--blockperiod: $QUORUM_BLOCKPERIOD"
echo -n "Are you sure you want to create a quorum? [Y/n]"
read -r quorum_create_confirm
quorum_create_confirm="${quorum_create_confirm:=Y}"

if [[ $quorum_create_confirm -ne Y ]]; then
    exit 1
fi
echo "🚀 Genesis Quorum..."
export QUORUM_CONSENSUS
export QUORUM_VALIDATORS
export QUORUM_NETWORK_ID
export QUORUM_BLOCKPERIOD

pwd=${PWD}

rm -rf artifacts/
rm -rf namespace/
rm -rf secrets/
rm -rf services/
rm -rf statefulsets/

# genesis quorum
npx quorum-genesis-tool --consensus $QUORUM_CONSENSUS --validators $QUORUM_VALIDATORS --chainID $QUORUM_NETWORK_ID --blockperiod $QUORUM_BLOCKPERIOD --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --members 0 --bootnodes 0 --outputPath 'artifacts'

yyyy=$(date '+%Y')
mv artifacts/$yyyy-*/* artifacts
rm -rf artifacts/$yyyy-*

echo "📝 Create Manifest ..."
# create manifest 
cd scripts/
. ./namespace.sh
# . ./configmap.sh
. ./secrets.sh
. ./services.sh
. ./statefulsets.sh

cd $pwd
echo "✅ Installation successfully completed! Now run deploy!"
