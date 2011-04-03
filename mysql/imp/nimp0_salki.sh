#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,cliente,f_fra,f_vto,concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from nimp_comersim natural join ncli_comersim where cod_cli>5010001 and cod_cli<5529999 order by cod_ag,cod_cli into outfile "$DIR/nsalki";
EOMYSQL

sed 's/&//g' <"$DIR/nsalki" >"$DIR/nsalki1"
tr '\t' '&' <"$DIR/nsalki1" >"$DIR/nsalki2"
sed 's/$/\\\\/g' <"$DIR/nsalki2" >"$DIR/nsalki3"

rm $DIR/nimp_salki/*
for i in $( ls $DIR/ag_salki/ ); do
	grep ^$i <$DIR/nsalki3 >$DIR/nimp_salki/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/nimp_salki/ag$i > $DIR/nimp_salki/agu$i
done
cp $DIR/nsalki3 $DIR/nimp_salki/ag99999
iconv -f ISO-8859-1 -t utf8 $DIR/nimp_salki/ag99999 > $DIR/nimp_salki/agu99999

for i in $( ls $DIR/ag_salki/ ); do
	cut -b 1-5 --complement <$DIR/nimp_salki/agu$i >$DIR/nimp_salki/$i
	rm $DIR/nimp_salki/ag$i
	rm $DIR/nimp_salki/agu$i
done

rm $DIR/nsalki*
rm -f $(find $DIR/nimp_salki/ -empty)
