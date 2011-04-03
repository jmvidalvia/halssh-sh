#!/bin/bash
DIR="/home/jm/mysql/imp"
HOY=`date +"%Y-%^m-%d"`

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),datediff(f_vto,date('$HOY')),format(eur,2),tipo_ef from vc_comersim natural join ncli_comersim where datediff(f_vto,date('$HOY')) < 30 and vc='V' and (tipo_ef='TR' or tipo_ef='RC' or tipo_ef='CH' or tipo_ef='CR' or tipo_ef='EF' or tipo_ef='GP' or tipo_ef='LA' or tipo_ef='PA') and eur>0 and cod_cli>5010001 and cod_cli<5529999 order by datediff(f_vto,date('$HOY')) into outfile "$DIR/ffsalki";
EOMYSQL

sed 's/&//g' <"$DIR/ffsalki" >"$DIR/ffsalki1"
tr '\t' '&' <"$DIR/ffsalki1" >"$DIR/ffsalki2"
sed 's/$/\\\\/g' <"$DIR/ffsalki2" >"$DIR/ffsalki3"

rm $DIR/ffimp_salki/*
for i in $( ls $DIR/ag_salki/ ); do
	grep ^$i <$DIR/ffsalki3 >$DIR/ffimp_salki/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_salki/ag$i > $DIR/ffimp_salki/agu$i
done
cp $DIR/ffsalki3 $DIR/ffimp_salki/ag99999
iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_salki/ag99999 > $DIR/ffimp_salki/agu99999

for i in $( ls $DIR/ag_salki/ ); do
	cut -b 1-6 --complement <$DIR/ffimp_salki/agu$i >$DIR/ffimp_salki/$i
	rm $DIR/ffimp_salki/ag$i
	rm $DIR/ffimp_salki/agu$i
done

rm $DIR/ffsalki*
rm -f $(find $DIR/ffimp_salki/ -empty)

