#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate
#chia show -s

UNUSED=`cat $HOME/.chia/mainnet/log/debug.log |grep 'does not exist' |awk '{print $6 }' |sort |uniq`

for dr in $UNUSED
do
  echo " processing $dr:"
  chia plots remove -d "$dr"
done

#/bin/bash
