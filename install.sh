#!/bin/bash
if [ ! -f chia-scripts/config.txt ]
then
echo "Config File NOT FOUND."
echo "please copy sample end edit it:"
echo "cp chia-scripts/config.txt.sample chia-scripts/config.txt"
echo "vi chia-scripts/config.txt"
exit 0
fi
(cd /home/chia/chia-blockchain/; . ./activate)
(cd chia-scripts; . ./activate)

sudo cp -v root-scripts/chia_* /usr/local/sbin/

echo "hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000
"  > /home/chia/.screenrc
chown chia:chia /home/chia/.screenrc

mkdir -p /home/chia/chia-scripts
chown chia:chia /home/chia/chia-scripts
cp -Rv chia-scripts/* /home/chia/chia-scripts/
