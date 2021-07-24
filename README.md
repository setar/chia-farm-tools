# chia-farm-tools
Linux scripts for organize big chia plotting and harvesting farm.

# install
```
git clone https://github.com/setar/chia-farm-tools.git
cd chia-farmer-tools
install.sh
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
