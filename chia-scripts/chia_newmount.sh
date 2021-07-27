#!/bin/bash
(cd ~/chia-scripts; . ./activate)
(cd /home/chia/chia-blockchain/; . ./activate)
#chia show -s

FARM=`ls -ld /home/chia/farm/* | awk '{print $9}'`

for dr in $FARM
do
  echo " processing $dr:"
  chia plots add -d "$dr"
done

#/bin/bash
