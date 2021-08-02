#!/bin/bash
. ~/chia-scripts/activate
. ~/chia-blockchain/activate

echo "Remove multiple copy of plots:"
MULT_COPY=`cat $HOME/.chia/mainnet/log/debug.log | grep 'multiple copies of the plot' | sed  "s/^.*\($FARM\/.*\.plot\).*$/\1/p" | sort | uniq`

for fn in $MULT_COPY
do
    [[ -f $fn ]] && ( echo "Remove $fn" ; rm -f $fn)
done

rm -f space_files
touch space_files
echo "Search space reserved for plots"
SPACE_FILES=`(cd $FARM ; find . -name '*.space' -type f -mmin +60 -print  | sed 's/.\///')` # maxtime for copy = 60 min ( -mmin +60 )
for fn in $SPACE_FILES
do
#    echo "Space $FARM/$fn"
    [[ -f $FARM/$fn ]] && ( echo "$FARM/${fn%.space}" >> space_files ;)
done

echo "Check used space of  plots"
for fn in $(cat space_files)
do
     echo " Check used space of Plot $fn"
     if [ -f "$fn.mover" ]
     then
          FILESIZE=`ls -la "$fn.mover"|awk '{print $5}'`
          RESERVED=`cat ${fn%.mover}.space`
          (( DIFF = $RESERVED - $FILESIZE ))
          echo "Real Filesize = $FILESIZE ; Reserved space = $RESERVED ; Diff = $DIFF"
          if [ $DIFF -lt 10 ]
          then # all size of plot already moved
              echo "    >>> File for rename $fn"
              mv "$fn.mover" $fn ; rm -f "$fn.space"
          else # diff size very big
             echo "    >>> drop old part of Plot $fn"
             rm -f "$fn.mover"
             rm -f "$fn.space"
          fi
     else
          echo "file $fn.mover not found"
          rm -f "$fn.space"
     fi
done

#chia show -s
#/bin/bash