#!/bin/zsh
. ~/chia-scripts/activate # chia-frm-tools env
#=================================================================================================================
# 05.2021 Sergey Taranenko aka setar@roboforum.ru
# script for moving ready chia plots
# Make moves finished plots from multiple sources to multiple destination directories with location control during the move.
# Can use multiple source hosts with one destination server without interfering with each other (space reservation)
#=================================================================================================================
#  Start Config data
#-----------------------------------------------------------------------------------------------------------------
SRC_DIRS="$CHIA_TEMP" # may be multiple via space
DST_ROOT="$CHIA_FARM" # root farm folder, single dir
STOP_DIRS="$DST_ROOT$|chia/temp" # egrep
MAX_COUNT=$CHIA_MAX_COUNT # maximum count of move process
DST_COUNT=$CHIA_DST_COUNT # count move process to one destination folder
DEBUG=$CHIA_DEBUG # true for debug mode
# SRC_DIRS : source directories for monitoring *.plot files
# DST_ROOT : is root folder for mount many single disks
# example
# DST_ROOT='/home/chia/farm'
# /home/chia/farm/4TB_1 : first mounted disk
# /home/chia/farm/4TB_2 : second mounted disk
# /home/chia/farm/16TB_other : trind mounted disk
# ... etc
# STOP_DIRS is exclude from destination folder list
# DEBUG : false / true
#
# set to crontab (edit script place and log):
# $ crontab -e
# * * * * * /home/chia/chia-scripts/chia_plots_mover.sh >>/home/chia/logs/plots_mover.log
#-----------------------------------------------------------------------------------------------------------------
#  End Config data
#=================================================================================================================
[[ ! -a /bin/zsh ]] && echo "This script need ZSH shell" #|| echo "Start script"
dt=$(date '+%d.%m.%Y %H:%M:%S');

count=`ps ax | grep -A 1 chia_plots_mover.sh |grep mv |grep plot |wc -l` # number of move process
[[  $DEBUG == "true" ]] &&echo "$dt Search source Plots"
for dir in ${=SRC_DIRS}
do # перебор исходных каталогов
  [[  $DEBUG == "true" ]] && echo "\n  Search in $dir:"
  for slen src in `find "$dir" -type f -name "*.plot" -printf '%s\t%p\n'`
  do # перебор готовых плотов
    filename=$src:t # возьмем имя файла из полного имени
    [[  $DEBUG == "true" ]] && echo "\n    Source:$src , len=$slen"
    [[  $DEBUG == "true" ]] && echo "      Destination search:"
    # зайдем в каждыйкаталог для вложенного nfs монтирования
    # for dirs in `find $DST_ROOT -type d` ; do cd $dirs ; done
    # поищем место в каталогах назначения
    dst_found=false # признак найденного назначения
    in_move=false # признак того что плот уже перемещается
    for dlen dst in `df |grep -E $DST_ROOT|grep -v -E $STOP_DIRS | awk '{ print $4,$6}'`
    do # перебор каталогов назначения
      dst_count=0 # процессов копирования в каталог назначения
      if [[  ( $dst_found = "false" && $in_move = "false" ) ]]
      then
        (( dlen = dlen * 1024 ))
        [[  $DEBUG == "true" ]] && echo "      check $dst, raw free $dlen"
        free=$dlen
        spacesize=0
        for spacefile in `find "$dst" -type f -name "*.space" -print0`
        do # проверка сколько места зарезервировано (объем резерва в файле имя_плота.space)
          if [[ ( $spacefile != '' && $spacefile != '\n' ) ]]
          then
            space_filename=${spacefile%.space}
            space_filename=$space_filename:t
            [[  $DEBUG == "true" ]] && echo "          space_filename=$space_filename"
            (( dst_count = dst_count + 1 ))
            if [[ "$space_filename" = "$filename" ]]
            then # этот файл уже в обработке
              [[  $DEBUG == "true" ]] && echo "      !!! plot $filename is already in moving"
              in_move=true
            else
            (( spacesize = spacesize + `cat "$spacefile"` ))
            [[  $DEBUG == "true" ]] && echo "          reserved for file ${spacefile%.space} SUM reserved:$spacesize "
            (( free = free - $spacesize ))
            fi
          else
            spacesize=0
          fi
        done
        [[  $DEBUG == "true" ]] && echo "          Free=$free"
        if [[ ( $free -gt $slen  && $in_move = "false" && $dst_count -lt $DST_COUNT ) ]]
        then # место позволяет сохраниться и плот еще не копируется и число процессов на назначение еще не превышено
            [[ $count -ge $MAX_COUNT ]] && exit 0 # выход из скрипта по достижению максимального кол-ва потоков
            [[  $DEBUG == "true" ]] && echo "          space found ($slen < $free)"
            echo "$slen" > $dst/$filename.space
            if [[ ! -a $dst/$filename.space ]] # check rw status of dst
            then # ro dst
              echo "ERROR: Destination $dst is RO filesystem"
            else # rw enable
              echo "\n$dt Start new move:"
              echo "mv $src $dst/$filename"
              dst_found=true
              `(mv $src $dst/$filename.mover ; mv $dst/$filename.mover $dst/$filename ; rm -f $dst/$filename.space)` &
              cd /home/chia/chia-blockchain/
              . ./activate
              chia plots add -d "$dst"
             (( count = count + 1 ))
           fi
        else # места для сохранения нет
#          [[  $DEBUG == "true" ]] && echo "          low space($free < $slen)"
        fi
      else
#        echo "      dst already found or plot in move"
      fi
    done
  done
done
