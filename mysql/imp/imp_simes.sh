#!/bin/bash
DIR="/home/jm/mysql/imp/imp_simes"
DIR1="/home/jm/sh/mysql/tex"
DIR2="/home/jm/mysql/imp/imp_simes_pdf"

cd $DIR2
cp $DIR1/simes.pdf .
for i in $( ls $DIR/ ); do
	sed -e "s/XXXX/${i}/g" <"$DIR1/imp_simes.tex" >"$DIR2/"$i".tex"
	pdflatex "$DIR2/"$i".tex"
	pdflatex "$DIR2/"$i".tex"
echo "Listado impagados" | mutt -s "info-hal" -a "$DIR2/"$i".pdf" $i
done
#echo "Listado impagados" | mutt -s "info-hal" -a $DIR2/"9999.pdf" 9999

