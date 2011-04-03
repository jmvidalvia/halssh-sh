#!/bin/bash
TABLA=simes
DIR="/home/jm/mysql/xcli/sortm_$TABLA"

rm $DIR/*
for i in $( ls /home/jm/mysql/imp/ag_$TABLA/ ); do
/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_cli,cliente,format(sum(vtas_act),2) as vtas_act,format((1-(sum(cst_act)/sum(vtas_act)))*100,2) as mgn_act,format((1-(sum(cst_ant)/sum(vtas_ant)))*100,2) as mgn_ant from $TABLA natural join ncli_$TABLA where cod_ag = '$i' and vtas_act > 1000 group by cod_cli having 1-(sum(cst_act)/sum(vtas_act)) < 0.35 order by 1-(sum(cst_act)/sum(vtas_act)) into outfile "$DIR/$i";
EOMYSQL
sed 's/&//g' <"$DIR/$i" >"$DIR/file1$i"
rm "$DIR/$i"
tr '\t' '&' <"$DIR/file1$i" >"$DIR/file2$i"
sed 's/$/\\\\/g' <"$DIR/file2$i" >"$DIR/file3$i"
sed 's/\´//g' <"$DIR/file3$i" >"$DIR/file4$i"
sed 's/\\N/--/g' <"$DIR/file4$i" >"$DIR/$i"
rm $DIR/file*

rm -f $(find $DIR/ -empty)
done

