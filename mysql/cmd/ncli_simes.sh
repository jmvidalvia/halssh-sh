#!/bin/bash
DB=dbsimes
DIR='Z:\My Dropbox\from_elcano'
EMP="SIMES"
FILE="LISTADO_DE_CLIENTES_"
DEST="/home/jm/Dropbox/from_elcano/cmd/"

echo '/connect discoverer/discoverer123@'$DB' /open "'$DIR'\dis\'$FILE$EMP'.DIS" /batch /export TEXT "'$DIR'\hal\'$FILE$EMP'.txt"' > $DEST$FILE$EMP.txt
