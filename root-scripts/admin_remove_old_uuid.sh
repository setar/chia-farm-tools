#!/bin/bash
#rescan-scsi-bus
MNT_MSG=`mount -a 2>mnt_msg`

cat mnt_msg | grep farm | grep "can't find UUID" | awk '{ print $5}' | sed 's/UUID="//' | sed 's/".//' >not_found_uuid
rm -f mnt_msg

cat /etc/fstab > fstab

echo "original fstab #lines : `cat fstab | wc -l`"

for uuid in $(cat not_found_uuid)
do
    echo " Exclude $uuid "
    cat fstab | grep -v "$uuid" > fstab.next
    mv -f fstab.next fstab
    rm -f /home/chia/$uuid
done
rm -f fstab.next

echo "fstab #lines without old uuid : `cat fstab | wc -l`"

cat fstab | sort | uniq > fstab.next
mv -f fstab.next fstab

echo "fstab #lines uniq : `cat fstab | wc -l`"
mv -f /etc/fstab /etc/fstab.old
mv -f fstab /etc/fstab

exit 0
