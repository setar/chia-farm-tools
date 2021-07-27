#!/bin/bash
sudo cp root-scripts/chia_bb /usr/local/sbin/chia_bb
sudo cp root-scripts/chia_log /usr/local/sbin/chia_log
sudo cp root-scripts/chia_mover /usr/local/sbin/chia_mover
sudo cp root-scripts/chia_swar /usr/local/sbin/chia_swar
sudo cp root-scripts/chia_cli /usr/local/sbin/chia_cli
sudo cp root-scripts/chia_log2 /usr/local/sbin/chia_log2
sudo cp root-scripts/chia_summary /usr/local/sbin/chia_summary

echo "hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000
"  > /home/chia/.screenrc
chown chia:chia /home/chia/.screenrc

cp chia-scripts/activate /home/chia/activate
cp chia-scripts/chia_del_unused_dirs.sh /home/chia/chia_del_unused_dirs.sh
cp chia-scripts/chia_newmount.sh /home/chia/chia_newmount.sh
cp chia-scripts/chia_swar.sh /home/chia/chia_swar.sh
cp chia-scripts/bb_create_nft.sh /home/chia/bb_create_nft.sh
cp chia-scripts/chia_log.sh /home/chia/chia_log.sh
cp chia-scripts/chia_plots_mover.sh /home/chia/chia_plots_mover.sh
cp chia-scripts/config.txt /home/chia/config.txt
cp chia-scripts/chia_bb.sh /home/chia/chia_bb.sh
cp chia-scripts/chia_log2.sh /home/chia/chia_log2.sh
cp chia-scripts/chia_startup.sh /home/chia/chia_startup.sh
cp chia-scripts/mm_create_nft.sh /home/chia/mm_create_nft.sh
cp chia-scripts/chia_cli.sh /home/chia/chia_cli.sh
cp chia-scripts/chia_mover.sh /home/chia/chia_mover.sh
cp chia-scripts/chia_summary.sh /home/chia/chia_summary.sh
cp chia-scripts/chia_plots_validator.sh /home/chia/chia_plots_validator.sh
