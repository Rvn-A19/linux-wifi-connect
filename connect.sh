#!/bin/bash

default_network_file="./default_wifi_network.txt"

ap_exists() {
  for ap in $(iw dev $1 scan | grep -i ssid | sed 's/SSID: //g'); do
    arg=`echo $ap | xargs`
    if [ "$ap" == "$2" ]; then
      echo $ap
      return 0
    fi
  done
  return 1
}

if [ `id -u` -ne 0 ]; then
  echo "You should be a superuser"
  exit 3
fi

wlan_name=`iw dev | grep -i interface | xargs | cut -f2 -d' '`
echo Wlan interface is $wlan_name

if [ -f $default_network_file ]; then
  ssid_name=`cat $default_network_file | ruby -e 'print $stdin.read.delete("\n")'`
else
  read -p 'SSID: ' ssid_name
fi

if [ ! "`ap_exists $wlan_name $ssid_name`" ]; then
  echo "There is no network $ssid_name"
  exit 3
fi

if [ ! -f /etc/wpa_supplicant/$ssid_name.conf ]; then
  echo "There is no /etc/wpa_supplicant/$ssid_name.conf; run encryption script first."
  return 4
fi

pkill -9 wpa_supplicant
ip link set $wlan_name down
ip link set $wlan_name up

wpa_supplicant -B -i $wlan_name -c /etc/wpa_supplicant/$ssid_name.conf
dhcpcd -w $wlan_name

