#!/bin/bash
rescan-scsi-bus
systemctl reset-failed
systemctl daemon-reload
systemctl reset-failed
mount -a

SYS_DSK=`l=0 ; while [ $l -le 5 ] ; do  wc=$(lsblk |grep -E -B $l "/$" |grep disk | awk '{print "\x27"$1"\x27"}'|wc -l) ; [[ $wc -eq 1 ]] && echo "$(lsblk |grep -E -B $l "/$" |grep disk | awk '{print "\x27"$1"\x27"}')" &&  break ;  (( l = l + 1 )) ; done`
RAID_DSK=`lsblk |grep -B 1 /home/chia/temp | grep nvme |grep disk | awk '{print "\x27"$1"\x27"}'`
MOUNTED_DSK=`blkid -o list |grep dev |grep -v 'not mounted' |egrep -v 'nvme|boot|device|mapper|/dev/md' |awk '{print "\x27"$1"\x27"}' | sed 's/\/dev\///'`

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
  NEW_UUID=`blkid -o list /dev/$ds |grep 'not mounted' | awk '{ print $5}'`
  NEW_FS=`blkid -o list /dev/$ds |grep 'not mounted' | awk '{ print $2}'`
  if [[ $NEW_UUID != '' ]]
  then
    mkdir /home/chia/farm/$NEW_UUID
    chown chia:chia /home/chia/farm/$NEW_UUID
    echo "UUID=\"$NEW_UUID\" /home/chia/farm/$NEW_UUID $NEW_FS noatime,nofail 0 0" >> /etc/fstab
    mount /dev/$ds
  fi
done

chown -Rv chia:chia /home/chia/farm
df -h
