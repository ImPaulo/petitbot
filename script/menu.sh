#!/bin/bash


#download fichier html du ru
wget -q --output-document="/home/exec/FBbot/files/menu1.html" https://www.crous-bordeaux.fr/restaurant/resto-u-n1/
wget -q --output-document="/home/exec/FBbot/files/menu2.html" https://www.crous-bordeaux.fr/restaurant/resto-u-n2/

#recup jour semaine
jour=$(date "+%A")
IDjour=$(date "+%-d")


#ligne du menu pour le jour de ma la semaine
beginLN1=$(cat -n /home/exec/FBbot/files/menu1.html | grep "Menu du $jour $IDjour" | cut -c 4-7)
beginLN2=$(cat -n /home/exec/FBbot/files/menu2.html | grep "Menu du $jour $IDjour" | cut -c 4-7)


#ligne du menu du midi
ligneMIDI1=$(($beginLN1+3))
ligneMIDI2=$(($beginLN2+3))


#recup de la ligne du midi
sed -n "$ligneMIDI1 p" /home/exec/FBbot/files/menu1.html > /home/exec/FBbot/files/export-menu1.txt
sed -n "$ligneMIDI2 p" /home/exec/FBbot/files/menu2.html > /home/exec/FBbot/files/export-menu2.txt

#remplacement chaine de caractère
sed -i -e "s/<div><h4>Déjeuner<\/h4><div class=\"content-repas\"><div>//g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<div><h4>Déjeuner<\/h4><div class=\"content-repas\"><div>//g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<span class=\"name\">/\\\\n\\\\n/g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<span class=\"name\">/\\\\n\\\\n/g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<\/span><ul class=\"liste-plats\"><li>/\\\\n/g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<\/span><ul class=\"liste-plats\"><li>/\\\\n/g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<\/li><li><\/li><li>/\\\\n/g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<\/li><li><\/li><li>/\\\\n/g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<\/li><li>/\\\\n/g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<\/li><li>/\\\\n/g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<\/li><\/ul>//g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<\/li><\/ul>//g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<\/div>//g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<\/div>//g" /home/exec/FBbot/files/export-menu2.txt

sed -i -e "s/<\/span>//g" /home/exec/FBbot/files/export-menu1.txt
sed -i -e "s/<\/span>//g" /home/exec/FBbot/files/export-menu2.txt


if [ $jour = "dimanche" ]; then
	echo "le RU est fermé aujourd'hui ma couille ! FDF" > /home/exec/FBbot/files/export-menu1.txt
	echo "le RU est fermé aujourd'hui ma couille ! FDF" > /home/exec/FBbot/files/export-menu2.txt
fi

if [ -z $ligneMIDI1 ]; then
	echo "le site est casse ! c'est pas ma faute et puis va falloir te calmer un peu ! FDF" > /home/exec/FBbot/files/export-menu1.txt
fi

if [ -z $ligneMIDI2 ]; then
	echo "le site est casse ! c'est pas ma faute et puis va falloir te calmer un peu ! FDF" > /home/exec/FBbot/files/export-menu2.txt
fi
