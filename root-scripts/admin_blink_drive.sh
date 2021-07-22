#!/bin/bash
DRIVES=(/sys/class/sas_device/end_device-*/device/target*/)

printf  ' %5s %8s %70s %10s %20s %10s %5s \n' "Slot" "Devname" "Path" "Vendor" "Model" "Fault" "Blink"
arraylength=${#DRIVES[@]}
for (( i=0; i<${arraylength}; i++ ));
do
    if [[ $(cat ${DRIVES[$i]}/*/type) != 0 ]]; then
        continue
    fi
    LOCATE=$(cat ${DRIVES[$i]}/*/enclosure_device*/locate)
    SLOT=$(cat ${DRIVES[$i]}/*/enclosure_device*/slot)
    VENDOR=$(cat ${DRIVES[$i]}/*/vendor)
    MODEL=$(cat ${DRIVES[$i]}/*/model)
    FAULT=$(cat ${DRIVES[$i]}/*/enclosure_device*/fault)
    DEVNAME=$(ls -d ${DRIVES[$i]}/*/block/*)
    printf  ' %5u %8s  %70s %10s %20s %10s %5u \n' "$SLOT" "$DEVNAME" "'${DRIVES[$i]}'" "$VENDOR" "$MODEL" "$FAULT" "$LOCATE"
done

