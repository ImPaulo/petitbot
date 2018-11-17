#!/bin/bash


#download fichier ics de l'edt
wget -q --auth-no-challenge --no-clobber --http-user=ahduzan --http-password=ahahatutecalmes --output-document="/home/exec/FBbot/files/edt.ics" "https://ade.bordeaux-inp.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=4662&projectId=2&calType=ical&firstDate=2018-08-27&lastDate=2019-02-08#&login"

#convertion fichier windows -> unix
find /home/exec/FBbot/files/edt.ics -type f -exec sed -i -e "s/\r$//" {} \;

#enlever caracteres qui ne passent pas : "\"
find /home/exec/FBbot/files/edt.ics -type f -exec sed -i -e "s/\\\//g" {} \;

#jour YMD
jour=$(date "+%Y%m%d")
day=$(date "+%A")

#ligne de la journee
lignes=$(cat -n /home/exec/FBbot/files/edt.ics | grep "DTSTART:$jour" | cut -c 3-7)

#Si dimanche, affiche pour le lundi
if [ $day = "dimanche" ]; then
	echo -n "C'est dimanche mais voila pour lundi chef !" >> /home/exec/FBbot/files/export-edt.txt
	jourSUN=$(date -d "tomorrow" "+%Y%m%d")
	lignes=$(cat -n /home/exec/FBbot/files/edt.ics | grep "DTSTART:$jourSUN" | cut -c 3-7)
fi


#Mettre heure de Deb dans tableau 
j=0;
for i in $lignes
do
	tpsTabDeb=$(head -$i /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 18-19 )
	tab[$j]=$tpsTabDeb
	j=$((j+1));
done

#Tri du tableau
sort_table=($( echo ${tab[*]} | sed -e 's/ /\n/g' | sort -n ))


#boucles pour tous les cours
k=0;
for j in ${sort_table[@]}
do
	for i in $lignes
	do
		tempDEB=$(head -$i /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 18-19 )
		
		if [ ${sort_table[$k]} = $tempDEB ]
		then
			heureDEBh=$((10#$tempDEB+1))
			heureDEBm=$(head -$i /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 20-21 )

			tempFIN=$(head -$(($i+1)) /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 16-17 )
			heureFINh=$((10#$tempFIN+1))
			heureFINm=$(head -$(($i+1)) /home/exec/FBbot/files/edt.ics | tail -1 | cut -c 18-19 )

			LNnom=$((10#$i+2));
			nom=$(head -$LNnom /home/exec/FBbot/files/edt.ics | tail -1 | awk -F : '{print $2}')

			LNsalle=$((10#$i+3));
			salle=$(head -$LNsalle /home/exec/FBbot/files/edt.ics | tail -1 | awk -F : '{print $2}')

			echo -n "\n\n$nom\n$heureDEBh:$heureDEBm - $heureFINh:$heureFINm\n$salle" >> /home/exec/FBbot/files/export-edt.txt
		fi
	done
	k=$((k+1));
done

echo "FDF" >> /home/exec/FBbot/files/export-edt.txt

if [ -z $lignes ]; then
	echo "Eh oh !! On n'a pas cours aujourd'hui, tu te calmes ou je te calme !! FDF" > /home/exec/FBbot/files/export-edt.txt
fi

