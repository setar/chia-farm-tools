#!/bin/bash
(cd /home/chia/chia-blockchain/; . ./activate)
tail -f /home/chia/.chia/mainnet/log/debug.log |grep -v full_node
