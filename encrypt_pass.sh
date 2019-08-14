#!/bin/bash

if [ `id -u` -ne 0 ]; then
  echo "You should be a superuser"
  exit 3
fi

read -p 'Wi-fi ESSID: ' essid
read -s -p 'Pass: ' pin ; echo

wpa_passphrase $essid $pin > /etc/wpa_supplicant/$essid.conf
chmod -r /etc/wpa_supplicant/$essid.conf

unset pin

