#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate
tail -f /home/chia/.chia/mainnet/log/debug.log |grep -E 'roof|pool' |grep -E 'farmer|harvester'