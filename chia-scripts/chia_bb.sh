#!/bin/bash
(cd ~/chia-scripts; . ./activate)
(cd /home/chia/chia-blockchain/; . ./activate)
cd ~
/home/chia/bb_create_nft.sh
/bin/bash
