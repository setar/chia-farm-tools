#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate
#chia show -s

FARM=`ls -ld $CHIA_FARM/* | awk '{print $9}'`

for dr in $FARM
do
  echo " processing $dr:"
  chia plots add -d "$dr"
done

#/bin/bash
