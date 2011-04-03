#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,cliente,f_fra,f_vto,concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from nimp_simes natural join ncli_simes order by cod_ag,cod_cli into outfile "$DIR/nsimes";
EOMYSQL

sed 's/&//g' <"$DIR/nsimes" >"$DIR/nsimes1"
tr '\t' '&' <"$DIR/nsimes1" >"$DIR/nsimes2"
sed 's/$/\\\\/g' <"$DIR/nsimes2" >"$DIR/nsimes3"

rm $DIR/nimp_simes/*
for i in $( ls $DIR/ag_simes/ ); do
	grep ^$i <$DIR/nsimes3 >$DIR/nimp_simes/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/nimp_simes/ag$i > $DIR/nimp_simes/agu$i
done
cp $DIR/nsimes3 $DIR/nimp_simes/ag9999
iconv -f ISO-8859-1 -t utf8 $DIR/nimp_simes/ag9999 > $DIR/nimp_simes/agu9999

for i in $( ls $DIR/ag_simes/ ); do
	cut -b 1-5 --complement <$DIR/nimp_simes/agu$i >$DIR/nimp_simes/$i
	rm $DIR/nimp_simes/ag$i
	rm $DIR/nimp_simes/agu$i
done

rm $DIR/nsimes*
rm -f $(find $DIR/nimp_simes/ -empty)
