#!/bin/bash



iwconfig
echo "Name of wifi interface ?"
read iface

sudo iwlist "$iface" scan | grep ESSID

echo "Which network to connect to ?"
read ntwrk

echo "Password of network ?"
read pwd

echo "Connection..."
wpa_passphrase "$ntwrk" "$pwd" | sudo tee /etc/wpa_supplicant.conf
wpa_supplicant -B -c /etc/wpa_supplicant.conf -i "$iface"
dhclient "$iface"

echo "Should work if no error"
iwconfig
ifconfig "$iface"
