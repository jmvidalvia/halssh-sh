#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from imp1_simes natural join ncli_simes order by cod_ag,cod_cli,n_fra into outfile "$DIR/simes";
EOMYSQL

sed 's/&//g' <"$DIR/simes" >"$DIR/simes1"
tr '\t' '&' <"$DIR/simes1" >"$DIR/simes2"
sed 's/$/\\\\/g' <"$DIR/simes2" >"$DIR/simes3"

rm $DIR/imp_simes/*
for i in $( ls $DIR/ag_simes/ ); do
	grep ^$i <$DIR/simes3 >$DIR/imp_simes/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/imp_simes/ag$i > $DIR/imp_simes/agu$i
done
cp $DIR/simes3 $DIR/imp_simes/ag9999
iconv -f ISO-8859-1 -t utf8 $DIR/imp_simes/ag9999 > $DIR/imp_simes/agu9999

for i in $( ls $DIR/ag_simes/ ); do
	cut -b 1-5 --complement <$DIR/imp_simes/agu$i >$DIR/imp_simes/$i
	rm $DIR/imp_simes/ag$i
	rm $DIR/imp_simes/agu$i
done

rm $DIR/simes*
rm -f $(find $DIR/imp_simes/ -empty)

NCLI0=0
DIR1=$DIR/imp_simes
for i in $( ls $DIR1 ); do
	cat $DIR1/$i | while read line; do
	NCLI1="${line:0:6}"
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

