#!/bin/bash
DB=dbsenco
DIR='Z:\My Dropbox\from_elcano'
EMP="COMERSIM"
FILE="IMP_"
DEST="/home/jm/Dropbox/from_elcano/cmd/"

echo '/connect discoverer/discoverer123@'$DB' /open "'$DIR'\dis\'$FILE$EMP'.DIS" /batch /export TEXT "'$DIR'\hal\'$FILE$EMP'.txt"' > $DEST$FILE$EMP.txt
