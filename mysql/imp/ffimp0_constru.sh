#!/bin/bash
DIR="/home/jm/mysql/imp"
HOY=`date +"%Y-%^m-%d"`

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),datediff(f_vto,date('$HOY')),format(eur,2),tipo_ef from vc_comersim natural join ncli_comersim where datediff(f_vto,date('$HOY')) < 30 and vc='V' and (tipo_ef='TR' or tipo_ef='RC' or tipo_ef='CH' or tipo_ef='CR' or tipo_ef='EF' or tipo_ef='GP' or tipo_ef='LA' or tipo_ef='PA') and eur>0 and cod_cli>1010001 and cod_cli<1529999 order by datediff(f_vto,date('$HOY')) into outfile "$DIR/ffconstru";
EOMYSQL

sed 's/&//g' <"$DIR/ffconstru" >"$DIR/ffconstru1"
tr '\t' '&' <"$DIR/ffconstru1" >"$DIR/ffconstru2"
sed 's/$/\\\\/g' <"$DIR/ffconstru2" >"$DIR/ffconstru3"

rm $DIR/ffimp_constru/*
for i in $( ls $DIR/ag_constru/ ); do
	grep ^$i <$DIR/ffconstru3 >$DIR/ffimp_constru/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_constru/ag$i > $DIR/ffimp_constru/agu$i
done
cp $DIR/ffconstru3 $DIR/ffimp_constru/ag88888
iconv -f ISO-8859-1 -t utf8 $DIR/ffimp_constru/ag88888 > $DIR/ffimp_constru/agu88888

for i in $( ls $DIR/ag_constru/ ); do
	cut -b 1-6 --complement <$DIR/ffimp_constru/agu$i >$DIR/ffimp_constru/$i
	rm $DIR/ffimp_constru/ag$i
	rm $DIR/ffimp_constru/agu$i
done

rm $DIR/ffconstru*
rm -f $(find $DIR/ffimp_constru/ -empty)

