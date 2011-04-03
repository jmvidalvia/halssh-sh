#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,cliente,f_fra,f_vto,concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from nimp_comersim natural join ncli_comersim where cod_cli>1010001 and cod_cli<1529999 order by cod_ag,cod_cli into outfile "$DIR/nconstru";
EOMYSQL

sed 's/&//g' <"$DIR/nconstru" >"$DIR/nconstru1"
tr '\t' '&' <"$DIR/nconstru1" >"$DIR/nconstru2"
sed 's/$/\\\\/g' <"$DIR/nconstru2" >"$DIR/nconstru3"

rm $DIR/nimp_constru/*
for i in $( ls $DIR/ag_constru/ ); do
	grep ^$i <$DIR/nconstru3 >$DIR/nimp_constru/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/nimp_constru/ag$i > $DIR/nimp_constru/agu$i
done
cp $DIR/nconstru3 $DIR/nimp_constru/ag88888
iconv -f ISO-8859-1 -t utf8 $DIR/nimp_constru/ag88888 > $DIR/nimp_constru/agu88888

for i in $( ls $DIR/ag_constru/ ); do
	cut -b 1-5 --complement <$DIR/nimp_constru/agu$i >$DIR/nimp_constru/$i
	rm $DIR/nimp_constru/ag$i
	rm $DIR/nimp_constru/agu$i
done

rm $DIR/nconstru*
rm -f $(find $DIR/nimp_constru/ -empty)
