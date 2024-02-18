#!/bin/bash

## ServerInColour v1.0
## Make your home page colorful and readable!
##
## Repository: https://github.com/medowic/serverincolour

## Uninstallation file

RED='\033[31m'
NC='\033[0m'

if [ "${EUID}" -ne 0 ]; then
    echo -e "${RED}[ ERROR ]${NC}: You need to run this script as root";
    exit 1;
fi

if [ -f /etc/systemd/system/sic-update.service ] || [ -d /root/.serverincolour ]; then
    rm -rf /root/.serverincolour
    rm /etc/systemd/system/sic-update.service
    systemctl daemon-reload >/dev/null 2>&1
fi

rm /etc/profile.d/sic.sh

echo ""
echo "ServerInColour was deleted"
echo "Now when you log in, you will see the standart system home screen."
echo ""

unset RED NC
exit 0
