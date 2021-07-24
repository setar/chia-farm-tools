#!/bin/bash
rescan-scsi-bus
systemctl reset-failed
systemctl daemon-reload
systemctl reset-failed
mount -a

SYS_DSK=`lsblk |grep -E -B 3 "/$" |grep disk | awk '{print "\x27"$1"\x27"}'`
RAID_DSK=`lsblk |grep -B 1 /home/chia/temp | grep nvme |grep disk | awk '{print "\x27"$1"\x27"}'`
MOUNTED_DSK=`blkid -o list |grep dev |grep -v 'not mounted' |egrep -v 'use|nvme|boot|device|mapper|/dev/md' |awk '{print "\x27"$1"\x27"}' | sed 's/\/dev\///'`

rm -f use_disks
rm -f new_disks
echo "$SYS_DSK" > use_disks
echo "$RAID_DSK" >> use_disks
echo "$MOUNTED_DSK" >> use_disks

NEW_DSK=`lsblk --raw |grep disk | awk '{print "\x27"$1"\x27"}'`
echo "$NEW_DSK" > new_disks

for uds in $(cat use_disks)
do
#    echo " Exclude $uds "
    cat new_disks | grep -v "$uds" > new_disks.next
    mv -f new_disks.next new_disks
done
rm -f new_disks.next
echo "New disks:"
cat new_disks

for ds in $(cat new_disks)
do
  ds=`echo $ds | sed "s/'//g"`
  echo "processing disk $ds"
  dd if=/dev/zero of=/dev/$ds bs=1M count=100
  mkfs.xfs -s size=512 -b size=4096  /dev/$ds
#  mkfs.xfs -s size=512 -b size=4096 -m bigtime=1 /dev/$ds
  NEW_UUID=`blkid -o list /dev/$ds |grep 'not mounted' | awk '{ print $5}'`
  if [[ $NEW_UUID != '' ]]
  then
    mkdir /home/chia/farm/$NEW_UUID
    chown chia:chia /home/chia/farm/$NEW_UUID
    echo "UUID=\"$NEW_UUID\" /home/chia/farm/$NEW_UUID xfs noatime,nofail 0 0" >> /etc/fstab
    mount /dev/$ds
  fi
done

chown -Rv chia:chia /home/chia/farm
df -h
