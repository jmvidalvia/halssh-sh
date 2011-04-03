#!/bin/bash
MES=`head -n 1 /home/jm/Dropbox/par/mes`
YR=`head -n 1 /home/jm/Dropbox/par/yr`
MES_NUM=`date +"%m"`
MES_TXT=`date -d "$YR-$MES-01" +%^b`
HOY=`date +"%d-%^b-%Y"`
INI=`date +"01-$MES_TXT-$YR"`
ULT=`echo $(cal $MES $YR) | awk '{print $NF}'`

if [ "$MES" = "$MES_NUM" ]
then FIN=$HOY
else FIN=`date +"$ULT-$MES_TXT-$YR"`
fi

echo $INI > /home/jm/sh/mysql/ini
echo $FIN > /home/jm/sh/mysql/fin




 
