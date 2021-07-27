#!/bin/bash
(cd ~/chia-scripts; . ./activate)
(cd /home/chia/chia-blockchain/; . ./activate)
cd /home/chia/Swar-Chia-Plot-Manager
python3 manager.py view
/bin/bash
