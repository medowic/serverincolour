#!/bin/bash

## ServerInColour v1.0
## Make your home page colorful and readable!
##
## Repository: https://github.com/medowic/serverincolour

## Installation file

RED='\033[31m'
ORANGE='\033[33m'
NC='\033[0m'

WORK_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "${EUID}" -ne 0 ]; then
    echo -e "${RED}[ ERROR ]${NC}: You need to run this script as root";
    exit 1;
fi

# shellcheck disable=SC1091
source /etc/os-release
OS_ID="${ID}"

if [ "${OS_ID}" == "ubuntu" ] || [ "${OS_ID}" == "debian" ] || [ "${OS_ID}" == "raspbian" ]; then
    mkdir /root/.serverincolour
    cp "${WORK_DIR}"/update-service.sh /root/.serverincolour
    cp "${WORK_DIR}"/sic-update.service /etc/systemd/system
    systemctl daemon-reload >/dev/null 2>&1
    systemctl enable sic-update >/dev/null 2>&1
else
    echo -e "${ORANGE}[ WARN ]${NC}: update information couldn't be displayed on your system"
fi
unset OS_ID RED ORANGE NC

cp "${WORK_DIR}"/sic.sh /etc/profile.d
chmod u+x /etc/profile.d/sic.sh
chmod 777 /etc/profile.d/sic.sh

echo ""
echo "ServerInColour was installed"
echo "Now when you log in, you will see the ServerInColour home screen"
echo ""
echo "For uninstall, use ./uninstall.sh in the same directory where located ./install.sh"
echo ""
exit 0