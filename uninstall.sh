#!/bin/bash

## ServerInColour Version 0.1-beta
## Make your home page colorful and readable!
##
## Uninstallation file
##
## Repository: https://github.com/medowic/serverincolour

RED='\033[31m'
ORANGE='\033[33m'
GREEN='\033[92m'
NC='\033[0m'

tput reset

echo "ServerInColour // Version 0.1-beta // Uninstall"
echo ""

## Check root

if [ "${EUID}" -ne 0 ]; then

    echo -e -n "${RED}You need to run this script as root.${NC} Are you root?";
    echo "";

    exit 1;

fi

## Start of code

rm /etc/profile.d/sic.sh

if [ "${?}" == "1" ]; then

    echo -e "${RED}Something went wrong...${NC}";
    echo "";
    echo "We couldn't delete general file ('sic.sh') in /etc/profile.d";
    echo "Sorry =(";
    echo "";

    exit 1;

fi

echo -e "${GREEN}Done!${NC} You successful deleted ServerInColour. Thank you for using."
echo ""
echo "Now when you log in, you will see the standart system home screen."
echo ""
echo -e "${ORANGE}We would be very grateful, if you could tell us why you deleted ServerInColour.${NC}"
echo "                Tell us about it in the discussion on GitHub"
echo ""
echo "            Repository: https://github.com/medowic/serverincolour"   
echo ""

exit 0