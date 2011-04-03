#!/bin/bash
MES=`head -n 1 /home/jm/Dropbox/par/mes`
YR=`head -n 1 /home/jm/Dropbox/par/yr`
FECHA="$YR-$MES-01"
DIR="/home/jm/mysql/vtas"
MAIL=jm@jmvidal.es,afernandez@desa.es,mreyes@desa.es

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select format(sum(vtas_act),2) from simes left outer join cli_grupo_ds on simes.cod_cli=cli_grupo_ds.cod_cli where cli_grupo_ds.cod_cli is null and simes.fecha="$FECHA" and simes.cod_cli>10000 into outfile "$DIR/simes";
select format(sum(vtas_act),2) from comersim left outer join cli_grupo_ds on comersim.cod_cli=cli_grupo_ds.cod_cli where cli_grupo_ds.cod_cli is null and comersim.fecha="$FECHA" and comersim.cod_cli>10000 and (tipo_alb="rra" or tipo_alb="rrar") into outfile "$DIR/salki";
select format(sum(vtas_act),2) from comersim left outer join cli_grupo_ds on comersim.cod_cli=cli_grupo_ds.cod_cli where cli_grupo_ds.cod_cli is null and comersim.fecha="$FECHA" and comersim.cod_cli>10000 and (tipo_alb="albexp" or tipo_alb="alerec" or tipo_alb="vva" or tipo_alb="vvar") into outfile "$DIR/ait";
EOMYSQL

echo simes `head -n 1 $DIR/simes` >$DIR/ventas.txt
echo salki `head -n 1 $DIR/salki` >>$DIR/ventas.txt
echo ait `head -n 1 $DIR/ait` >>$DIR/ventas.txt

echo `cat $DIR/ventas.txt` | mutt -s "info-hal" $MAIL
rm $DIR/*
