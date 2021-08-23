#!/bin/bash
if [ ! -f chia-scripts/config.txt ]
then
echo "Config File NOT FOUND."
echo "please copy sample end edit it:"
echo "cp chia-scripts/config.txt.sample chia-scripts/config.txt"
echo "vi chia-scripts/config.txt"
exit 0
fi

USER=`cat chia-scripts/config.txt | grep -v '#' | sed "s/ //g;s/'//g;s/\"//g" | grep user | sed "s/user=//"`
echo "Chia user : $USER"

CHIA_HOME=`su - $USER -c 'echo $HOME'`

echo "Chia user home: $CHIA_HOME"

sudo chown root:root
sudo chmod 700 root-scripts/chia_*
sudo cp -vf root-scripts/chia_* /usr/local/sbin/

sudo echo "hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000
"  > $CHIA_HOME/.screenrc
sudo chown $USER:$USER $CHIA_HOME/.screenrc

sudo mkdir -p $CHIA_HOME/chia-scripts
sudo cp -Rv chia-scripts/* $CHIA_HOME/chia-scripts/
sudo chown -R $USER:$USER $CHIA_HOME/chia-scripts
sudo chmod 700 $CHIA_HOME/chia-scripts/*.sh
