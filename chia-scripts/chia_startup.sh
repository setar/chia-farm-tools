#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate
chia start farmer
chia show -a introducer-eu.chia.net:8444

#cd $HOME/Swar-Chia-Plot-Manager
#python3 manager.py start

