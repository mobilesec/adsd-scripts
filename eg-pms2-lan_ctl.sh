#!/bin/bash

###########################################################################
# Script zum ansteuern der EG-PMS2-(W)LAN Steckdosenleiste                #
# ACHTUNG Passwort wird unverschlüsselt an die Steckdosenleiste gesendet! #
# geschrieben von daice, April 2017                                       #
#                                                                         #
# Aufruf: eg-pms2-lan_ctl.sh  'ip' 'socket' 'command'                     #
# ip:     IP-Adresse der Steckdosenleiste, welche angesteuert werden soll #
# socket: Nummer des anzusteuernden Sockets (1/2/3/4)                     #
# cmd:    auszuführende Funktion (on/off/state)                           #
###########################################################################

#Passwor für Steckdosenleist angeben
password=12345678

#Überprüfen ob Gerät erreichbar ist
ping -q -c1 $1 >/dev/null 2>&1

if [ $? -eq 0 ]
  then

    #Anmeldung an der Steckdosenleiste
    curl -X POST -sd 'pw='$password'' http://$1/login.html >/dev/null 2>&1

    if [ "$3" = "off" ]
      then
        curl -sd 'cte'$2'=0' http://$1 >/dev/null 2>&1

    elif [ "$3" = "on" ]
      then
        curl -sd 'cte'$2'=1' http://$1 >/dev/null 2>&1

    elif [ "$3" = "state" ]
      then
        let pos=$2*2
        curl -s http://$1/status.html | sed -e 's,.*var ctl = ,,' -e 's,var tod.*,,' | cut -c $pos- | cut -c -1
    fi

    #Abmeldung von der Steckdosenleiste
    curl -X GET http://$1/login.html >/dev/null 2>&1

else

  #Rückmeldung, wenn Gerät nicht erreichbar
  echo 0
#  echo "Gerät nicht erreichbar"
fi

