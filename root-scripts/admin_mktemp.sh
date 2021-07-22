#!/bin/bash
# тут менять дискки NVMe (!все данные с них будут уничтожены) и их кол-во
mdadm --create /dev/md0 --level=stripe --raid-devices=3 --chunk=512 /dev/sdb /dev/sdc /dev/sdd
# дальше менять ничего не нужно
mkfs.xfs -s size=512 -b size=4096 /dev/md0
TMPUUID=`blkid /dev/md0 | awk '{ print $2}'`
echo "$TMPUUID /home/chia/temp xfs noatime 0 0" >> /etc/fstab
mount -a
chown chia:chia -R /home/chia/temp
chmod 775 -R  /home/chia/temp
