#!/bin/bash
EMPRESA=SIMES
TABLA=simes
MES=`head -n 1 /home/jm/Dropbox/par/mes`
YR=`head -n 1 /home/jm/Dropbox/par/yr`
FECHA="$YR-$MES-01"
DIR="/home/jm/Dropbox"
VTAS="VENTAS_X_FAMILIA_"$EMPRESA"_"$MES".txt"
CLI="LISTADO_DE_CLIENTES_"$EMPRESA".txt"
IMP="IMP_"$EMPRESA".txt"
VC="CARTERA_VC_"$EMPRESA".txt"

cd $DIR/from_elcano/hal
iconv -f ISO-8859-1 -t utf8 $VTAS > $DIR"/pna/utf8_"$VTAS
iconv -f ISO-8859-1 -t utf8 $CLI > $DIR"/pna/utf8_"$CLI
iconv -f ASCII -t utf8 $VC > $DIR"/pna/utf8_"$VC
iconv -f ASCII -t utf8 $IMP > $DIR"/pna/utf8_"$IMP

sed 's/\.//g' <$DIR"/pna/utf8_"$VTAS >$DIR"/pna/ok_utf8_"$VTAS
rm $DIR"/pna/utf8_"$VTAS
sed 's/,/./g' <$DIR"/pna/ok_utf8_"$VTAS >$DIR"/pna/ok_ok_utf8_"$VTAS
rm $DIR"/pna/ok_utf8_"$VTAS

sed 's/\.//g' <$DIR"/pna/utf8_"$IMP >$DIR"/pna/ok_utf8_"$IMP
rm $DIR"/pna/utf8_"$IMP
sed 's/,/./g' <$DIR"/pna/ok_utf8_"$IMP >$DIR"/pna/ok_ok_utf8_"$IMP
rm $DIR"/pna/ok_utf8_"$IMP

sed 's/\.//g' <$DIR"/pna/utf8_"$VC >$DIR"/pna/ok_utf8_"$VC
rm $DIR"/pna/utf8_"$VC
sed 's/,/./g' <$DIR"/pna/ok_utf8_"$VC >$DIR"/pna/ok_ok_utf8_"$VC
rm $DIR"/pna/ok_utf8_"$VC

mv $DIR"/pna/utf8_"$CLI $DIR"/pna/ok_utf8_"$CLI

/usr/bin/mysql --password=hd883l --database=pna<<EOMYSQL
delete from $TABLA where fecha='$FECHA';
load data local infile '$DIR/pna/ok_ok_utf8_$VTAS' into table $TABLA ignore 3 lines;
truncate ncli_$TABLA;
load data local infile '$DIR/pna/ok_utf8_$CLI' into table ncli_$TABLA ignore 3 lines;
truncate vc_$TABLA;
load data local infile '$DIR/pna/ok_ok_utf8_$VC' into table vc_$TABLA ignore 1 lines;
truncate imp0_$TABLA;
insert into imp0_$TABLA select * from imp1_$TABLA;
truncate imp1_$TABLA;
load data local infile '$DIR/pna/ok_ok_utf8_$IMP' into table imp1_$TABLA ignore 1 lines;
update imp1_$TABLA set fecha='$FECHA';
delete from imp_$TABLA where fecha='$FECHA';
insert into imp_$TABLA select * from imp1_$TABLA;
truncate nimp_$TABLA;
insert into nimp_simes select imp1_simes.* from imp1_simes left outer join imp0_simes on concat(imp1_simes.n_fra,imp1_simes.n_sec)=concat(imp0_simes.n_fra,imp0_simes.n_sec) where imp0_simes.eur is null;
delete from xmes_$TABLA where fecha='$FECHA';
insert into xmes_$TABLA select ncli_simes.cod_ag,sum(simes.vtas_act) as vtas_act,sum(simes.cst_act) as cst_act,sum(simes.vtas_ant) as vtas_ant,sum(simes.cst_ant) as cst_ant,'$FECHA' as fecha from simes left outer join cli_grupo_ds on simes.cod_cli=cli_grupo_ds.cod_cli left join ncli_simes on simes.cod_cli = ncli_simes.cod_cli where cli_grupo_ds.cod_cli is null and fecha='$FECHA' and simes.cod_cli>10000 group by cod_ag;
delete from xmes_imp_$TABLA where fecha='$FECHA';
insert into xmes_imp_$TABLA select cod_ag,sum(eur) as imp,'$FECHA' as fecha from imp_simes natural join ncli_simes where fecha='$FECHA' group by cod_ag;
EOMYSQL

