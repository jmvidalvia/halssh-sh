#!/bin/bash
DIR="/home/jm/mysql/imp"
HOY=`date +"%Y-%^m-%d"`

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),datediff(f_vto,date('$HOY')),format(eur,2),tipo_ef from vc_simes natural join ncli_simes where datediff(f_vto,date('$HOY')) < 30 and vc='V' and (tipo_ef='TR' or tipo_ef='RC' or tipo_ef='CH' or tipo_ef='CR' or tipo_ef='EF' or tipo_ef='GP' or tipo_ef='LA' or tipo_ef='PA') and eur>0 and (cod_sect='0110' or cod_sect='0111' or cod_sect='0406') order by datediff(f_vto,date('$HOY')) into outfile "$DIR/ffasimes";
EOMYSQL

sed 's/&//g' <"$DIR/ffasimes" >"$DIR/ffasimes1"
tr '\t' '&' <"$DIR/ffasimes1" >"$DIR/ffasimes2"
sed 's/$/\\\\/g' <"$DIR/ffasimes2" >"$DIR/ffasimes3"

cp $DIR/ffasimes3 $DIR/ffimp_simes/ag6666
iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_simes/ag6666 > $DIR/ffimp_simes/agu6666
cut -b 1-5 --complement <$DIR/ffimp_simes/agu6666 >$DIR/ffimp_simes/6666
rm $DIR/ffimp_simes/ag6666
rm $DIR/ffimp_simes/agu6666

rm $DIR/ffasimes*
rm -f $(find $DIR/ffimp_simes/ -empty)

