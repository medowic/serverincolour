#!/bin/bash

## ServerInColour Version 0.1-beta
## Make your home page colorful and readable!
##
## Installation file
##
## Repository: https://github.com/medowic/serverincolour

RED='\033[31m'
ORANGE='\033[33m'
GREEN='\033[92m'
NC='\033[0m'

WORK_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

tput reset

echo "ServerInColour // Version 0.1-beta // Install"
echo ""

## Check root

if [ "${EUID}" -ne 0 ]; then

    echo -e -n "${RED}You need to run this script as root.${NC} Are you root?";
    echo "";

    exit 1;

fi

## Check file exist

if ! [ -f "${WORK_DIR}/sic.sh" ]; then

    echo -e "${RED}Cannot to find 'sic.sh' (general) file.${NC}";
    echo "Re-download git-repository and try again.";
    echo "";
    
    exit 1;

fi

## Start of code

cp "${WORK_DIR}"/sic.sh /etc/profile.d

if [ "${?}" == "1" ]; then

    echo -e "${RED}Something went wrong...${NC}";
    echo "";
    echo "We couldn't copy general file to /etc/profile.d";
    echo "Sorry =(";
    echo "";

    exit 1;

fi

chmod u+x /etc/profile.d/sic.sh
chmod 777 /etc/profile.d/sic.sh

echo -e "${GREEN}Done!${NC} You successful installed ServerInColour. Thank you for install! =)"
echo ""
echo "Now when you log in, you will see the ServerInColour home screen."
echo -e "And remember - ${ORANGE}this is beta-version${NC}. If you see a bug or just have a suggestion, tell us about it at GitHub discussion!"
echo ""
echo "                       Repository: https://github.com/medowic/serverincolour"   
echo ""
echo "For uninstall, check https://github.com/medowic/serverincolour#Uninstall"
echo ""

exit 0