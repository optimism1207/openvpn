#!/bin/bash

#written by gx

read -p "name: " name
read -p "password: " password

cd /etc/openvpn/easy-rsa-c/

if [ -d "/etc/openvpn/easy-rsa-c/pki" ];then
    rm -rf /etc/openvpn/easy-rsa-c/pki
fi

/usr/bin/expect /etc/openvpn/auto/client_req.expect $name $password

sleep 1s

cd /etc/openvpn/easy-rsa/

/usr/bin/expect /etc/openvpn/auto/import_sign.expect $name $password

sleep 1s

if [ -f "/etc/openvpn/easy-rsa/pki/issued/$name.crt" ];then
    dir="/etc/openvpn/client/$name"
    mkdir $dir
    cp /etc/openvpn/easy-rsa/pki/ca.crt $dir
    cp /etc/openvpn/easy-rsa/pki/issued/$name.crt $dir
    cp /etc/openvpn/easy-rsa-c/pki/private/$name.key $dir
    cp /etc/openvpn/easy-rsa/ta.key $dir

    sleep 1s

    cp /etc/openvpn/sample.ovpn $dir/$name.ovpn
    cd $dir
    sed -i '/<ca>/r ca.crt' $name.ovpn
    sed -i '/<cert>/r '"$name"'.crt' $name.ovpn
    sed -i '/<key>/r '"$name"'.key' $name.ovpn
    sed -i '/<tls-auth>/r ta.key' $name.ovpn
else
    echo "$name.crt doesn't exist, exit."
fi  

