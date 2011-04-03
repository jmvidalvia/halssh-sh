#!/bin/bash
INI=`head -n 1 /home/jm/sh/mysql/ini`
FIN=`head -n 1 /home/jm/sh/mysql/fin`
DB=dbsenco
DIR='Z:\My Dropbox\from_elcano'
MES=`head -n 1 /home/jm/Dropbox/par/mes`
EMP="COMERSIM"
FILE="VENTAS_X_FAMILIA_"
DEST="/home/jm/Dropbox/from_elcano/cmd/"

echo '/connect discoverer/discoverer123@'$DB' /open "'$DIR'\dis\'$FILE$EMP'.DIS" /parameter FECHA_DESDE '$INI' /parameter FECHA_HASTA '$FIN' /sheet 1 /batch /export TEXT "'$DIR'\hal\'$FILE$EMP'_'$MES'.txt"' > $DEST$FILE$EMP.txt
