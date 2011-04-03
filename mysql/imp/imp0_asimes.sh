#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from imp1_simes natural join ncli_simes where (cod_sect='0110' or cod_sect='0111' or cod_sect='0406') order by cod_ag,cod_cli,n_fra into outfile "$DIR/asimes";
EOMYSQL

sed 's/&//g' <"$DIR/asimes" >"$DIR/asimes1"
tr '\t' '&' <"$DIR/asimes1" >"$DIR/asimes2"
sed 's/$/\\\\/g' <"$DIR/asimes2" >"$DIR/asimes3"

cp $DIR/asimes3 $DIR/imp_simes/ag6666
iconv -f ISO-8859-1 -t utf8 $DIR/imp_simes/ag6666 > $DIR/imp_simes/agu6666
cut -b 1-5 --complement <$DIR/imp_simes/agu6666 >$DIR/imp_simes/6666
rm $DIR/imp_simes/ag6666
rm $DIR/imp_simes/agu6666

rm $DIR/asimes*
rm -f $(find $DIR/imp_simes/ -empty)

NCLI0=0
DIR1=$DIR/imp_simes
	cat $DIR1/6666 | while read line; do
	NCLI1="${line:0:6}"
	if [ "$NCLI1" != "$NCLI0" ];
	then
		echo "\midrule" >> $DIR1/a6666 
		NCLI0="$NCLI1"
	fi
	echo "$line"\\ >> $DIR1/a6666 
done
rm $DIR1/6666
sed '1d' $DIR1/a6666 >$DIR1/6666
rm $DIR1/a6666
