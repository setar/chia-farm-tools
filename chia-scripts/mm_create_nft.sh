#!/bin/bash
. ~/chia-scripts/activate
$HOME/chia-plotter/build/chia_plot -n -1 -r $CHIA_THREADS -u 256 -t $CHIA_TEMP/ -2 $CHIA_RAM/ -K 1 -f $CHIA_FPK -c $CHIA_NFT
