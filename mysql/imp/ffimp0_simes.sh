#!/bin/bash
DIR="/home/jm/mysql/imp"
HOY=`date +"%Y-%^m-%d"`

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),datediff(f_vto,date('$HOY')),format(eur,2),tipo_ef from vc_simes natural join ncli_simes where datediff(f_vto,date('$HOY')) < 30 and vc='V' and (tipo_ef='TR' or tipo_ef='RC' or tipo_ef='CH' or tipo_ef='CR' or tipo_ef='EF' or tipo_ef='GP' or tipo_ef='LA' or tipo_ef='PA') and eur>0 order by datediff(f_vto,date('$HOY')) into outfile "$DIR/ffsimes";
EOMYSQL

sed 's/&//g' <"$DIR/ffsimes" >"$DIR/ffsimes1"
tr '\t' '&' <"$DIR/ffsimes1" >"$DIR/ffsimes2"
sed 's/$/\\\\/g' <"$DIR/ffsimes2" >"$DIR/ffsimes3"


rm $DIR/ffimp_simes/*
for i in $( ls $DIR/ag_simes/ ); do
	grep ^$i <$DIR/ffsimes3 >$DIR/ffimp_simes/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_simes/ag$i > $DIR/ffimp_simes/agu$i
done
cp $DIR/ffsimes3 $DIR/ffimp_simes/ag9999
iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_simes/ag9999 > $DIR/ffimp_simes/agu9999

for i in $( ls $DIR/ag_simes/ ); do
	cut -b 1-5 --complement <$DIR/ffimp_simes/agu$i >$DIR/ffimp_simes/$i
	rm $DIR/ffimp_simes/ag$i
	rm $DIR/ffimp_simes/agu$i
done

rm $DIR/ffsimes*
rm -f $(find $DIR/ffimp_simes/ -empty)

