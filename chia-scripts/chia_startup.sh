#!/bin/bash
(cd ~/chia-scripts; . ./activate)
( cd /home/chia/chia-blockchain/; . ./activate )
chia start farmer
chia show -a introducer-eu.chia.net:8444

#cd /home/chia/Swar-Chia-Plot-Manager
#python3 manager.py start

