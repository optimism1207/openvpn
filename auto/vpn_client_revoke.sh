#!/bin/bash

#written by gx

read -p "Enter the client name to revoke: " name
read -p "Enter the passwd: " passwd

cd /etc/openvpn/

/etc/openvpn/auto/client_revoke.expect $name $passwd

sleep 1s

\cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem


