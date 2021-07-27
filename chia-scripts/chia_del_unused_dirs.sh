#!/bin/bash
(cd /home/chia/chia-blockchain/; . ./activate)
#chia show -s




UNUSED=`cat /home/chia/.chia/mainnet/log/debug.log |grep 'does not exist' |awk '{print $6 }' |sort |uniq`

for dr in $UNUSED
do
  echo " processing $dr:"
  chia plots remove -d "$dr"
done

#/bin/bash
