#!/bin/bash

IP_REGEX='^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$'

if [[ $UID -ne 0 ]]; then
    echo run as root
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo missing IP address argument
    exit 1
fi

if ! [[ $1 =~ $IP_REGEX ]]; then
    echo invalild IP address argument
    exit 1
fi

IP=$1

sudo touch /media/fbertagna/boot/ssh

sudo cat >> /media/fbertagna/rootfs/etc/dhcpcd.conf << EOF
interface eth0
static ip_address=$IP/24
static routers=192.168.2.1
static domain_name_servers=192.168.2.1 8.8.8.8
EOF

sudo cp ./scripts/rpi-init.sh /media/fbertagna/rootfs/root/
