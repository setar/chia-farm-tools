# chia-farm-tools
Linux scripts for organize big chia plotting and harvesting farm.
[Русскоязычное описание](https://github.com/setar/chia-farm-tools/blob/main/README_RU.md)

# pre requests
* zsh
* worked ntpd # highly recomended
* installed and configured chia environment 
  * adduser chia
  * usermod -aG sudo chia
  * mkdir /home/chia/temp
  * chown chia:chia /home/chia/temp
  * mkdir /home/chia/farm
  * chown chia:chia /home/chia/farm
  * mkdir /home/chia/ram
  * chown chia:chia /home/chia/ram
  * mkdir /home/chia/logs
  * chown chia:chia /home/chia/logs
  * mount -o size=220G -t tmpfs none /home/chia/temp/ # if used madmax plotter (110GB for every ploting process )
  * nano /etc/fstab # if used madmax plotter
  * add new mount point "tmpfs		/home/chia/ram	tmpfs	rw,noatime,nosuid,size=220G	0 0"
  * echo "hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000
"  > ~/.screenrc
  * echo "hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000
"  > /home/chia/.screenrc
  * chown chia:chia /home/chia/.screenrc

# install
```
sudo -i
cd ~
git clone https://github.com/setar/chia-farm-tools.git
cd chia-farmer-tools
cp chia-scripts/config.txt.sample chia-scripts/config.txt
nano chia-scripts/config.txt # set you parameters hier
install.sh
```

# install chia (only for example)
```
chia_cli
cd ~
git clone https://github.com/Chia-Network/chia-blockchain.git -b main --recurse-submodules
cd chia-blockchain
chmod +x ./install.sh
sh install.sh
. ./activate
chia init
chia keys add # yuo secrets words hier
chia keys show
chia start farmer
chia show -a introducer-eu.chia.net:8444
chia configure -upnp false
chia configure --log-level INFO
chia start farmer -r
Ctrl+A,d

chia_log
```

# cron jobs
chia_cli
crontab -e
```
@reboot sh /home/chia/chia-scripts/chia_startup.sh
* * * * * /home/chia/chia-scripts/chia_plots_mover.sh >>/home/chia/logs/plots_mover.log
```

# use
```
chia_* : scripts for root, every execute named screen process.
* dettach from screen : Ctrl+a,d
* exit and close screen : Ctrl+d,Ctrl+d
```
## chia management scripts
```
chia_log # show chia log in screen
chia_log2 # show alt log in screen (full log)
chia_cli # execute chia cli env in screen
chia_mover # show plots mover log in screen (w/o full_node info)
chia_bb # execute bladebit plotter in screen
chia_swar # execute swar plotter in screen
chia_summary # show summary info in screen
chia_plots_validator # check and remove multiple plots (by logs of chia farmer), find and delete lost part of plots move
```
## root admin scripts
```
root-scripts/admin_mktemp.sh # format nvme !!! need edit before use !!!
root-scripts/admin_newmount.sh # search not mounted disks , wipe header , format , registred in fstab and mount it !!! DANGER - all disk will be erased !!!
root-scripts/admin_remove_old_uuid.sh # remove uuid folder and fstab record after dettach any drive
root-scripts/admin_blink_drive.sh 
root-scripts/admin_check_bad_disks.sh
root-scripts/admin_chia_ionice.sh
```
