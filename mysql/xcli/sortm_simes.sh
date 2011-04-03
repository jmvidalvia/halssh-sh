#!/bin/bash
DIR="/home/jm/mysql/xcli/sortm_simes"
DIR1="/home/jm/sh/mysql/tex"
DIR2="/home/jm/mysql/xcli/sortm_simes_pdf"

cd $DIR2
cp $DIR1/simes.pdf .
for i in $( ls $DIR/ ); do
	sed -e "s/XXXX/${i}/g" <"$DIR1/sortm_simes.tex" >"$DIR2/"$i".tex"
	pdflatex "$DIR2/"$i".tex"
	pdflatex "$DIR2/"$i".tex"
#echo "ABC ventas y margen" | mutt -s "info-hal" -a "$DIR2/"$i".pdf" $i
done
#echo "ABC ventas y margen" | mutt -s "info-hal" -a "$DIR2/"$i".pdf" 5555

