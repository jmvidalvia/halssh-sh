#!/bin/bash
DIR="/home/jm/mysql/imp"

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
select cod_ag,cod_cli,left(cliente,35),date_format(f_fra,'%d/%m/%y'),date_format(f_vto,'%d/%m/%y'),concat(n_fra,'-',n_sec),format(eur,2),format(15+eur*1.06,2) as neto from imp1_comersim natural join ncli_comersim where cod_cli>6010431 and cod_cli<6529999 order by cod_ag,cod_cli,n_fra into outfile "$DIR/ait";
EOMYSQL

sed 's/&//g' <"$DIR/ait" >"$DIR/ait1"
tr '\t' '&' <"$DIR/ait1" >"$DIR/ait2"
sed 's/$/\\\\/g' <"$DIR/ait2" >"$DIR/ait3"

rm $DIR/imp_ait/*
for i in $( ls $DIR/ag_ait/ ); do
	grep ^$i <$DIR/ait3 >$DIR/imp_ait/ag$i
	iconv -f ISO-8859-1 -t utf8 $DIR/imp_ait/ag$i > $DIR/imp_ait/agu$i
done
cp $DIR/ait3 $DIR/imp_ait/ag77777
iconv -f ISO-8859-1 -t utf8 $DIR/imp_ait/ag77777 > $DIR/imp_ait/agu77777

for i in $( ls $DIR/ag_ait/ ); do
	cut -b 1-6 --complement <$DIR/imp_ait/agu$i >$DIR/imp_ait/$i
	rm $DIR/imp_ait/ag$i
	rm $DIR/imp_ait/agu$i
done

rm $DIR/ait*
rm -f $(find $DIR/imp_ait/ -empty)

NCLI0=0
DIR1=$DIR/imp_ait
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

