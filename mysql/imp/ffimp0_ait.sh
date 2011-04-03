#!/bin/bash
DIR="/home/jm/mysql/imp"
HOY=`date +"%Y-%^m-%d"`

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),datediff(f_vto,date('$HOY')),format(eur,2),tipo_ef from vc_comersim natural join ncli_comersim where datediff(f_vto,date('$HOY')) < 30 and vc='V' and (tipo_ef='TR' or tipo_ef='RC' or tipo_ef='CH' or tipo_ef='CR' or tipo_ef='EF' or tipo_ef='GP' or tipo_ef='LA' or tipo_ef='PA') and eur>0 and cod_cli>6010431 and cod_cli<6529999 order by datediff(f_vto,date('$HOY')) into outfile "$DIR/ffait";
EOMYSQL

sed 's/&//g' <"$DIR/ffait" >"$DIR/ffait1"
tr '\t' '&' <"$DIR/ffait1" >"$DIR/ffait2"
sed 's/$/\\\\/g' <"$DIR/ffait2" >"$DIR/ffait3"

rm $DIR/ffimp_ait/*
for i in $( ls $DIR/ag_ait/ ); do
	grep ^$i <$DIR/ffait3 >$DIR/ffimp_ait/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_ait/ag$i > $DIR/ffimp_ait/agu$i
done
cp $DIR/ffait3 $DIR/ffimp_ait/ag77777
iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_ait/ag77777 > $DIR/ffimp_ait/agu77777

for i in $( ls $DIR/ag_ait/ ); do
	cut -b 1-6 --complement <$DIR/ffimp_ait/agu$i >$DIR/ffimp_ait/$i
	rm $DIR/ffimp_ait/ag$i
	rm $DIR/ffimp_ait/agu$i
done

rm $DIR/ffait*
rm -f $(find $DIR/ffimp_ait/ -empty)

