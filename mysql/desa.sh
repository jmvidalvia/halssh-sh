#!/bin/bash
TABLA=desa
MES=`head -n 1 /home/jm/Dropbox/par/mes`
YR=`head -n 1 /home/jm/Dropbox/par/yr`
FECHA="$YR-$MES-01"
DIR=/home/jm/Dropbox/bcn
FTP=/home/ftp
VTAS=$DIR"/whal"$MES"_utf8"
CLI=$DIR"/whal_cli_utf8"

cd $FTP
for file in *
	do iconv -f ISO-8859-1 -t utf8 $file > $DIR/$file"_utf8"
done

sed 's/,//g' <$VTAS >$VTAS"_ok"
VTAS=$VTAS"_ok"

/usr/bin/mysql --password=hd883l --database=bcn<<EOMYSQL
delete from $TABLA where fecha='$FECHA';
load data local infile '$VTAS' into table $TABLA ignore 4 lines;
truncate ncli_$TABLA;
load data local infile '$CLI' replace into table ncli_$TABLA ignore 4 lines;
EOMYSQL

