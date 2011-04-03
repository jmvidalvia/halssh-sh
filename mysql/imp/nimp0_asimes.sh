#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,cliente,f_fra,f_vto,concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from nimp_simes natural join ncli_simes where (cod_sect='0110' or cod_sect='0111' or cod_sect='0406') order by cod_ag,cod_cli into outfile "$DIR/nasimes";
EOMYSQL

sed 's/&//g' <"$DIR/nasimes" >"$DIR/nasimes1"
tr '\t' '&' <"$DIR/nasimes1" >"$DIR/nasimes2"
sed 's/$/\\\\/g' <"$DIR/nasimes2" >"$DIR/nasimes3"

cp $DIR/nasimes3 $DIR/nimp_simes/ag6666
iconv -f ISO-8859-1 -t utf8 $DIR/nimp_simes/ag6666 > $DIR/nimp_simes/agu6666
cut -b 1-5 --complement <$DIR/nimp_simes/agu6666 >$DIR/nimp_simes/6666
rm $DIR/nimp_simes/ag6666
rm $DIR/nimp_simes/agu6666

rm $DIR/nasimes*
rm -f $(find $DIR/nimp_simes/ -empty)
