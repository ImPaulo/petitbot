#!/bin/bash

echo "$(date '+%Y %m %d %H:%M:%S')    DEBUT DU SCRIPT BY ARTHURHIMSELF"
echo "$(date '+%Y %m %d %H:%M:%S')    --------------------------------"


#forcer langue en FR
export LANG=fr_FR.utf8
export LC_ALL=fr_FR.utf8

#suppr anciens fichiers
echo "$(date '+%Y %m %d %H:%M:%S')    suppression des anciens fichiers"
rm /home/exec/FBbot/files/* > /dev/null 2>&1 &

#stop old instance script
echo "$(date '+%Y %m %d %H:%M:%S')    kill de l'ancienne instance"
pkill -f node


#chargement des menus
echo "$(date '+%Y %m %d %H:%M:%S')    traitement des menus"
/home/exec/FBbot/script/menu.sh

#chargement de l'emploi du temps
echo "$(date '+%Y %m %d %H:%M:%S')    traitement de l'emploi du temps"
/home/exec/FBbot/script/edt.sh

#chargement de l'emploi du temps de demain - Attention depend de edt.sh
echo "$(date '+%Y %m %d %H:%M:%S')    traitement de l'emploi du temps pour demain"
/home/exec/FBbot/script/demain.sh


#chargement de la meteo
echo "$(date '+%Y %m %d %H:%M:%S')    traitement de la meteo"
python /home/exec/FBbot/script/meteo.py


#ecritude dans le fichier du bot facebook
echo "$(date '+%Y %m %d %H:%M:%S')    ecriture des donnees dans le fichier de reponse du bot"
echo "{
	\"/menu1\": \"$(cat /home/exec/FBbot/files/export-menu1.txt | awk -F FDF '{print $1}')\",
	\"/menu2\": \"$(cat /home/exec/FBbot/files/export-menu2.txt | awk -F FDF '{print $1}')\",
	\"/edt\": \"$(cat /home/exec/FBbot/files/export-edt.txt | awk -F FDF '{print $1}')\",
	\"/demain\": \"$(cat /home/exec/FBbot/files/export-demain.txt | awk -F FDF '{print $1}')\",
	\"/meteo\": \"$(cat /home/exec/FBbot/files/export-meteo.txt | awk -F FDF '{print $1}')\",
	\"/retard\": \"Alleeeeez, tu dois payer les croissants et les chocolatines maintenant !!!\",
	\"/xavier\": \"c c c c'est t t tcp ii ippp AhAhHaha, tu connais la blague de l'ingé sys et du programeur ?\",
	\"/rattrapage\": \"Démarche qui consiste à reprendre, à tenter de rattraper quelque chose... plus communément appelé un Maxime Teitgen. La note de Maxime d'aujourd'hui : $(( $RANDOM % 10)) ! A demain pour une nouvelle note\",
	\"/alive\": \"nique ta mère, I'm stayin' alive stayin' alive Ah ah Ah ah stayin' aliiiiiiiiiiiiivvvvve !!!\",
	\"/list\": \"menu1 - menu2 - edt - demain - meteo - retard - xavier - rattrapage - alive - bite - quentin\",
	\"/quentin\": \"coiiiiiin coiiiiiiiiiiiin quentiiiiiiin\",
  	\"/bite\": \"non je ne parle pas de maxime teitgen, noooon voyons !! hehe\"
}" > /home/exec/FBbot/facebook-chat-bot/database/respond.json


#lancement bot facebook
echo "$(date '+%Y %m %d %H:%M:%S')    lancement du bot"
cd /home/exec/FBbot/facebook-chat-bot/
npm start &
