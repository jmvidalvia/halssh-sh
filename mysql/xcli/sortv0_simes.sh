#!/bin/bash
TABLA=simes
DIR="/home/jm/mysql/xcli/sortv_$TABLA"

rm $DIR/*
for i in $( ls /home/jm/mysql/imp/ag_$TABLA/ ); do
/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_cli,cliente,format(sum(vtas_act),2) as vtas_act,format(sum(vtas_ant),2) as vtas_ant,format(sum(vtas_act)-sum(vtas_ant),2) as dif from $TABLA natural join ncli_$TABLA where cod_ag = '$i' group by cod_cli having (sum(vtas_act)-sum(vtas_ant)) < 0 order by sum(vtas_act)-sum(vtas_ant) limit 20 into outfile "$DIR/$i";
EOMYSQL
sed 's/&//g' <"$DIR/$i" >"$DIR/file1$i"
rm "$DIR/$i"
tr '\t' '&' <"$DIR/file1$i" >"$DIR/file2$i"
sed 's/$/\\\\/g' <"$DIR/file2$i" >"$DIR/file3$i"
sed 's/\´//g' <"$DIR/file3$i" >"$DIR/$i"
rm $DIR/file*

rm -f $(find $DIR/ -empty)
done

for i in $( ls $DIR/ ); do
/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_cli,cliente,format(sum(vtas_act),2) as vtas_act,format(sum(vtas_ant),2) as vtas_ant,format(sum(vtas_act)-sum(vtas_ant),2) as dif from $TABLA natural join ncli_$TABLA where cod_ag = '$i' group by cod_cli having (sum(vtas_act)-sum(vtas_ant)) > 0 order by sum(vtas_act)-sum(vtas_ant) desc limit 20 into outfile "$DIR/a$i";
EOMYSQL
sed 's/&//g' <"$DIR/a$i" >"$DIR/file1$i"
rm "$DIR/a$i"
tr '\t' '&' <"$DIR/file1$i" >"$DIR/file2$i"
sed 's/$/\\\\/g' <"$DIR/file2$i" >"$DIR/file3$i"
sed 's/\´//g' <"$DIR/file3$i" >"$DIR/a$i"
rm $DIR/file*

echo \\midrule >> "$DIR/$i"
cat "$DIR/a$i" >> "$DIR/$i"
rm "$DIR/a$i"

done

