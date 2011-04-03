#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,cliente,f_fra,f_vto,concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from nimp_comersim natural join ncli_comersim where cod_cli>6010431 and cod_cli<6529999 order by cod_ag,cod_cli into outfile "$DIR/nait";
EOMYSQL

sed 's/&//g' <"$DIR/nait" >"$DIR/nait1"
tr '\t' '&' <"$DIR/nait1" >"$DIR/nait2"
sed 's/$/\\\\/g' <"$DIR/nait2" >"$DIR/nait3"

rm $DIR/nimp_ait/*
for i in $( ls $DIR/ag_ait/ ); do
	grep ^$i <$DIR/nait3 >$DIR/nimp_ait/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/nimp_ait/ag$i > $DIR/nimp_ait/agu$i
done
cp $DIR/nait3 $DIR/nimp_ait/ag77777
iconv -f ISO-8859-1 -t utf8 $DIR/nimp_ait/ag77777 > $DIR/nimp_ait/agu77777

for i in $( ls $DIR/ag_ait/ ); do
	cut -b 1-5 --complement <$DIR/nimp_ait/agu$i >$DIR/nimp_ait/$i
	rm $DIR/nimp_ait/ag$i
	rm $DIR/nimp_ait/agu$i
done

rm $DIR/nait*
rm -f $(find $DIR/nimp_ait/ -empty)
