#!/bin/bash
spider0=/home/jm/sh/spider/spider0
spider1=/home/jm/sh/spider/spider1
DIR=/home/jm/sh/spider
MAIL=jm@jmvidal.es,agoma@desa.es,esteban.konyay@grupo-ds.es

cd $DIR
wget http://dl.dropbox.com/u/3018975/vtas_grupo.pdf --spider -S >&$spider1
cero=`cat $spider0 | grep content-length`
uno=`cat $spider1 | grep content-length`
if [ "$cero" != "$uno" ]
	then 
		wget http://dl.dropbox.com/u/3018975/vtas_grupo.pdf
		pdftoppm -f 1 -l 1 -x 30 -W 1600 -y 140 -H 500 vtas_grupo.pdf vtas && convert vtas-1.ppm vtas.png
		echo "Ventas actualizadas" | mutt -s "info-hal" -a $DIR/vtas.png $MAIL && cp $spider1 $spider0 && rm vtas*
	else exit
fi
