!#/bin/bash
#realtime for farmer and harvester
ionice -c 1 -p `cat /home/chia/.chia/mainnet/run/chia_harvester.pid`
ionice -c 1 -p `cat /home/chia/.chia/mainnet/run/chia_farmer.pid`

