#!/bin/bash

## ServerInColour v1.0
## Make your home page colorful and readable!
##
## Repository: https://github.com/medowic/serverincolour

## Update service for APT

if ! [ -d /tmp/serverincolour ]; then
    mkdir /tmp/serverincolour;
fi

# shellcheck disable=SC1091
source /etc/os-release
OS_ID="${ID}"

if [ "${OS_ID}" == "ubuntu" ] || [ "${OS_ID}" == "debian" ] || [ "${OS_ID}" == "raspbian" ]; then
    UPDATES=$(apt update | tail -q -n1);
    ERRLEVEL="${?}";
    if [ "${ERRLEVEL}" == "0" ]; then
        echo "UPDATES=\"${UPDATES}\"" | tee /tmp/serverincolour/updates.tmp;
    fi
fi

unset OS_ID ERRLEVEL UPDATES
exit 0