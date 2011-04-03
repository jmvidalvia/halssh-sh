#!/bin/bash
DIR="/home/jm/mysql/imp/nimp_salki"
DIR1="/home/jm/sh/mysql/tex"
DIR2="/home/jm/mysql/imp/nimp_salki_pdf"

cd $DIR2
cp $DIR1/salki.pdf .
for i in $( ls $DIR/ ); do
	sed -e "s/XXXX/${i}/g" <"$DIR1/nimp_salki.tex" >"$DIR2/"$i".tex"
	pdflatex "$DIR2/"$i".tex"
	pdflatex "$DIR2/"$i".tex"
#echo "Listado nuevos impagados" | mutt -s "info-hal" -a "$DIR2/"$i".pdf" $i
done
echo "Listado impagados" | mutt -s "info-hal" -a $DIR2/"99999.pdf" 99999

