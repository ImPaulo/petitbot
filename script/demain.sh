#!/bin/bash


#jour YMD
jour=$(date "+%Y%m%d" --date="+1 day")
day=$(date "+%A" --date="+1 day")

#ligne de la journee
lignes=$(cat -n /home/exec/FBbot/files/edt.ics | grep "DTSTART:$jour" | cut -c 3-7)

#Si dimanche, affiche pour le lundi
if [ $day = "dimanche" ]; then
	echo -n "demain c'est dimanche alors tu te calmes !" >> /home/exec/FBbot/files/export-demain.txt
fi


#boucles pour tous les cours
for i in $lignes
do
	tempDEB=$(head -$i /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 18-19 )
	heureDEBh=$((10#$tempDEB+1))
	heureDEBm=$(head -$i /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 20-21 )

	tempFIN=$(head -$(($i+1)) /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 16-17 )
	heureFINh=$((10#$tempFIN+1))
	heureFINm=$(head -$(($i+1)) /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 18-19 )

	LNnom=$((10#$i+2));
	nom=$(head -$LNnom /home/exec/FBbot/files/edt.ics | tail -1 | awk -F : '{print $2}')

	LNsalle=$((10#$i+3));
	salle=$(head -$LNsalle /home/exec/FBbot/files/edt.ics | tail -1 | awk -F : '{print $2}')

	echo -n "\n\n$nom\n$heureDEBh:$heureDEBm - $heureFINh:$heureFINm\n$salle" >> /home/exec/FBbot/files/export-demain.txt
done

echo "FDF" >> /home/exec/FBbot/files/export-demain.txt

if [ -z $lignes ]; then
	echo "Eh oh !! On n'a pas cours demain, tu te calmes ou je te calme !! FDF" > /home/exec/FBbot/files/export-demain.txt
fi
