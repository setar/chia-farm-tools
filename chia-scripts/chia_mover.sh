#!/bin/bash
(cd ~/chia-scripts; . ./activate)
(cd /home/chia/chia-blockchain/; . ./activate)
tail -f /home/chia/logs/plots_mover.log

