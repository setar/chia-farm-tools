#!/bin/bash
BAD_DISKS=`dmesg | grep 'I/O error' | grep 'blk_update_request' | awk '{print $7}' | sed 's/,//'|sort | uniq`
echo "Bad disks:"
echo $BAD_DISKS
