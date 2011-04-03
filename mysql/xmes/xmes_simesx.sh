#!/bin/bash
DIR="/home/jm/mysql/xmes"
MES=`head -n 1 /home/jm/Dropbox/par/mes`
YR=`head -n 1 /home/jm/Dropbox/par/yr`
FECHA="$YR-$MES-01"


/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,left(agente,25) as agente,format(sum(vtas_act),0) as vtas_act,format((1-(sum(cst_act)/sum(vtas_act)))*100,2) as mgen,format(sum(vtas_ant),0) as vtas_ant,format(sum(vtas_act)-sum(vtas_ant),0) as dif,format(sum(obj_simes.obj),0) as obj,format((sum(vtas_act)-sum(obj)),0) as dif,format(sum(xmes_imp_simes.imp),0) as imp from xmes_simes natural left join ag_simes natural left join obj_simes natural left join xmes_imp_simes where fecha='$FECHA' and cod_ag > 4999 group by cod_ag into outfile "$DIR/simesx";
EOMYSQL

sed 's/&//g' <"$DIR/simesx" >"$DIR/simesx1"
tr '\t' '&' <"$DIR/simesx1" >"$DIR/simesx2"
sed 's/$/\\\\/g' <"$DIR/simesx2" >"$DIR/simesx3"
sed 's/\\N//g' <"$DIR/simesx3" >"$DIR/ok_det_simesx"
rm $DIR/sim*

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select '' as cod_ag,'TOTAL' as agente,format(sum(vtas_act),0) as vtas_act,format((1-(sum(cst_act)/sum(vtas_act)))*100,2) as mgen,format(sum(vtas_ant),0) as vtas_ant,format(sum(vtas_act)-sum(vtas_ant),0) as dif,format(sum(obj_simes.obj),0) as obj,format((sum(vtas_act)-sum(obj)),0) as dif,format(sum(xmes_imp_simes.imp),0) as imp from xmes_simes natural left join ag_simes natural left join obj_simes natural left join xmes_imp_simes where fecha='$FECHA' and cod_ag > 4999 group by cod_ag into outfile "$DIR/simesx";
EOMYSQL

sed 's/&//g' <"$DIR/simesx" >"$DIR/simesx1"
tr '\t' '&' <"$DIR/simesx1" >"$DIR/simesx2"
sed 's/$/\\\\/g' <"$DIR/simesx2" >"$DIR/simesx3"
sed 's/\\N//g' <"$DIR/simesx3" >"$DIR/ok_tot_simesx"
rm $DIR/sim*

cat $DIR/ok_det_simesx > $DIR/ok_simesx
echo "\midrule" >> $DIR/ok_simesx
cat $DIR/ok_tot_simesx >> $DIR/ok_simesx

DIR1="/home/jm/sh/mysql/tex"
DIR2="/home/jm/mysql/xmes/pdf"

cd $DIR2
cp $DIR1/simes.pdf .
cp $DIR1/xmes_simesx.tex $DIR2/xmes_simesx.tex
	pdflatex $DIR2/xmes_simesx.tex
	pdflatex $DIR2/xmes_simesx.tex
#echo "Listado de ventas" | mutt -s "info-hal" -a $DIR2/xmes_simesx.pdf 9999

rm $DIR/ok*
