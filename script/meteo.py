#!/usr/bin/python
# -*- coding: utf-8 -*-


#import pour les infos meteo
import os.path
import urllib2
import json
import sys


#lecture des donnees via AP
page_json = urllib2.urlopen('http://dataservice.accuweather.com/forecasts/v1/daily/1day/131906?apikey=l5Qxv8ESQMMbOSDcGipHEK7BCm8pAoa9&language=fr-FR&metric=true')
json_string = page_json.read()
parsed_json = json.loads(json_string)
page_json.close()


#donnees dans des variables
day = parsed_json['DailyForecasts'][int('0')]['Day']['IconPhrase']
night = parsed_json['DailyForecasts'][int('0')]['Night']['IconPhrase']
tempsmin = parsed_json['DailyForecasts'][int('0')]['Temperature']['Minimum']['Value']
tempsmax = parsed_json['DailyForecasts'][int('0')]['Temperature']['Maximum']['Value']


#ecriture dans le fichier d'export
with open('/home/exec/FBbot/files/export-meteo.txt', 'w') as f:
    f.write("METEO DE TALENCE, FRANCE" + "\\n")
    f.write("la journee : " + day.encode('utf8') + "\\n")
    f.write("la nuit : " + night.encode('utf8') + "\\n")
    f.write("Temperature min : " + str(tempsmin) + " °C\\n")
    f.write("Temperature max : " + str(tempsmax) + " °C")


