#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate

DISKS=`ls -d $CHIA_FARM/*`
FARM_Q=$(echo $CHIA_FARM | sed 's/\//\\\//g')
for DSK in $DISKS
do
    echo "Check Plots in folder: $DSK"
    LOW_Q=`chia plots check -n 100 -g "$DSK" 2>&1 |grep 'ERROR'|grep 'in getting challenge qualities' | sed  "s/^.*\($FARM_Q\/.*\.plot\).*$/\1/p"`
    for fn in $LOW_Q
    do
        echo "remove $fn"
    done
done
