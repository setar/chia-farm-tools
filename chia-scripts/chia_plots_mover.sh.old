#!/bin/zsh
#=================================================================================================================
# 05.2021 Sergey Taranenko aka setar@roboforum.ru
# script for moving ready chia plots
# Make moves finished plots from multiple sources to multiple destination directories with location control during the move.
# Can use multiple source hosts with one destination server without interfering with each other (space reservation)
# TODO : now script use single forked move procces in one time, may be need many threads ?
#=================================================================================================================
#  Start Config data
#-----------------------------------------------------------------------------------------------------------------
SRC_DIRS='/home/chia/temp' # may be multiple via space
DST_ROOT='/home/chia/farm' # single folder
STOP_DIRS="$DST_ROOT$|chia/temp" # egrep
DEBUG=true
# SRC_DIRS : source directories for monitoring *.plot files
# DST_ROOT : is root folder for mount many single disks
# example
# DST_ROOT='/home/chia/nfs'
# /home/chia/nfs/4TB_1 : first mounted disk
# /home/chia/nfs/4TB_2 : second mounted disk
# /home/chia/nfs/16TB_other : trind mounted disk
# ... etc
# STOP_DIRS is exclude from destination folder list
# DEBUG : false / true
#
# set to crontab (edit script place and log):
# $ crontab -e
# * * * * * /home/chia/chia_plots_mover.sh >>/home/chia/plots_mover.log
#-----------------------------------------------------------------------------------------------------------------
#  End Config data
#=================================================================================================================



[[ ! -a /bin/zsh ]] && echo "This script need ZSH shell" #|| echo "Start script"

dt=$(date '+%d.%m.%Y %H:%M:%S');
dst_found=false # признак найденного назначения 
[[  $DEBUG == "true" ]] &&echo "$dt Search source Plots"
for dir in ${=SRC_DIRS}
do # перебор исходных каталогов
  [[  $DEBUG == "true" ]] && echo "\n  Search in $dir:"
  for slen src in `find "$dir" -type f -name "*.plot" -print0 | du --files0-from=-`
  do # перебор готовых плотов
    filename=$src:t # возьмем имя файла из полного имени
    [[  $DEBUG == "true" ]] && echo "\n    Source:$src , len=$slen"
    [[  $DEBUG == "true" ]] && echo "\n      Destination search:"
    # зайдем в каждыйкаталог для вложенного nfs монтирования
    for dirs in `find $DST_ROOT -type d` ; do cd $dirs ; done
    # посмотрим место в каталогах назначения
    for dlen dst in `df |grep -E $DST_ROOT|grep -v -E $STOP_DIRS | awk '{ print $4,$6}'`
    do # перебор каталогов назначения
      if [[  $dst_found = "false"  ]]
      then
        [[  $DEBUG == "true" ]] && echo "      $dst, raw free $dlen"
        free=$dlen
        for spacefile in `find "$dst" -type f -name "*.space" -print0`
        do # проверка сколько места зарезервировано (объем резерва в файле имя_плота.space)
          if [[ ( $spacefile != '' && $spacefile != '\n' ) ]]
          then
            space_filename=${spacefile%.space}
            space_filename=$space_filename:t
            [[  $DEBUG == "true" ]] && echo "space_filename=$space_filename"
            if [[ "$space_filename" = "$filename" ]]
            then # этот файл уже в обработке
              echo "$dt Plot $filename is already in moving"
              return 0
            fi
            spacesize=`cat "$spacefile"`
            [[  $DEBUG == "true" ]] && echo "      reserved:$spacesize for ${spacefile%.space}"
            (( free = free - $spacesize ))
          else
            spacesize=0
          fi
        done
        [[  $DEBUG == "true" ]] && echo "      Free:$free"
        if [ $free -gt $slen  ]
        then # место позволяет сохраниться
            [[  $DEBUG == "true" ]] && echo "      copy to hier ($slen < $free)"
            dst_found=true
            echo "$slen" > $dst/$filename.space
            echo "$dt Start new move:"
            echo "mv $src $dst/$filename && rm -f $dst/$filename.space &"
            `mv $src $dst/$filename.mover && mv $dst/$filename.mover $dst/$filename && rm -f $dst/$filename.space ` &
            cd /home/chia/chia-blockchain/
            . ./activate
            chia plots add -d "$dst"
            return 0
        else # места для сохранения нет
          [[  $DEBUG == "true" ]] && echo "      low space($free < $slen)"
        fi
      else
#        echo "      dst already found"
      fi
    done
  done
done
