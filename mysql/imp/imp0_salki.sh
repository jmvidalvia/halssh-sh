#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from imp1_comersim natural join ncli_comersim where cod_cli>5010001 and cod_cli<5529999 order by cod_ag,cod_cli,n_fra into outfile "$DIR/salki";
EOMYSQL

sed 's/&//g' <"$DIR/salki" >"$DIR/salki1"
tr '\t' '&' <"$DIR/salki1" >"$DIR/salki2"
sed 's/$/\\\\/g' <"$DIR/salki2" >"$DIR/salki3"

rm $DIR/imp_salki/*
for i in $( ls $DIR/ag_salki/ ); do
	grep ^$i <$DIR/salki3 >$DIR/imp_salki/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/imp_salki/ag$i > $DIR/imp_salki/agu$i
done
cp $DIR/salki3 $DIR/imp_salki/ag99999
iconv -f ISO-8859-1 -t utf8 $DIR/imp_salki/ag99999 > $DIR/imp_salki/agu99999

for i in $( ls $DIR/ag_salki/ ); do
	cut -b 1-6 --complement <$DIR/imp_salki/agu$i >$DIR/imp_salki/$i
	rm $DIR/imp_salki/ag$i
	rm $DIR/imp_salki/agu$i
done

rm $DIR/salki*
rm -f $(find $DIR/imp_salki/ -empty)

NCLI0=0
DIR1=$DIR/imp_salki
for i in $( ls $DIR1 ); do
	cat $DIR1/$i | while read line; do
	NCLI1="${line:0:7}"
	if [ "$NCLI1" != "$NCLI0" ];
	then
		echo "\midrule" >> $DIR1/a$i 
		NCLI0="$NCLI1"
	fi
	echo "$line"\\ >> $DIR1/a$i 
done
rm $DIR1/$i
sed '1d' $DIR1/a$i >$DIR1/$i
done
rm $DIR1/a*

