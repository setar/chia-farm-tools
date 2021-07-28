#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate
echo "Farmer Publc Key = $FPK"
echo "Pool Contract Address = $NFT"
echo "Chia user = $USER"
echo "Chia user homedir = $HOME"
echo "Chia user tempdir = $TEMP"
echo "Chia user ramdir = $RAM"
chia farm summary
/bin/bash
