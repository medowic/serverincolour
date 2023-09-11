#!/bin/bash

## ServerInColour Version 0.1-beta
## Make your home page colorful and readable!
##
## Repository: https://github.com/medowic/serverincolour

tput reset

RED='\033[31m'
ORANGE='\033[33m'
GREEN='\033[92m'
NC='\033[0m'

## Home page function

function loginPage() {

    tput reset

    source /etc/os-release
    source /tmp/.serverincolour/updates

    if [ -z "${UPDATES}" ]; then

        UPDATES="${ORANGE}N/A - It looks like you don't have a 'sudo' command.${NC}";

    fi

## Variables about OS and other

    OS="${NAME}"
    OS_VERSION_FULL="${VERSION}"
    OS_DOCUMENTATION="${SUPPORT_URL}"

    LINUX_CORE_VERSION_O=$(uname -o)
    LINUX_CORE_VERSION_MR=$(uname -mr)

    CPU_CORES=$(cat /proc/cpuinfo | grep 'processor' | wc -l)

    SYS_LOAD=$(cat /proc/loadavg | cut -d ' ' -f1)

## CPU temperature check

    if [ -f /sys/devices/virtual/thermal/thermal_zone0/temp ]; then

        THERMAL_ZONE="/sys/devices/virtual/thermal/thermal_zone0/temp";

    elif [ -f /sys/class/hwmon/hwmon/temp1_input ]; then

        THERMAL_ZONE="/sys/class/hwmon/hwmon/temp1_input";

    else

        THERMAL_ZONE="";

    fi

    if [ -n "${THERMAL_ZONE}" ]; then

        CPU_TEMPERATURE_TMP=$(cat ${THERMAL_ZONE});
        ((CPU_TEMPERATURE_TMP = CPU_TEMPERATURE_TMP / 100));
        CPU_TEMPERATURE=$(echo "${CPU_TEMPERATURE_TMP}" | sed -r 's/(.{1})$/.\1/');

        if [ ${CPU_TEMPERATURE_TMP} -gt 500 ] && [ ${CPU_TEMPERATURE_TMP} -lt 800 ]; then

            CPU_COLOR='\033[33m';

        elif [ ${CPU_TEMPERATURE_TMP} -gt 800 ]; then

            CPU_COLOR='\033[31m';

        else

            CPU_COLOR='\033[92m';

        fi

    else

        CPU_COLOR='\033[33m';

        CPU_TEMPERATURE="N/A";

    fi

## Start of home page

    DISK_MASSIVE=1

    tput reset

    echo "Welcome to ${OS} ${OS_VERSION_FULL} (${LINUX_CORE_VERSION_O} ${LINUX_CORE_VERSION_MR})!"
    echo "ServerInColour // Version: 0.1-beta"
    echo ""
    echo " ! System documentation: ${OS_DOCUMENTATION}"
    echo ""
    echo "ServerInColour Repository: https://github.com/medowic/serverincolour"
    echo ""
    echo "    Have a bug or suggestion with ServerInColour?"
    echo "    Tell us about it in discussion at repository!"
    echo ""
    echo -n "System information as of "
        date
    echo ""
    echo -e "    Mem usage: ${MEM_COLOR}${HUMAN_MEM_TAKE}${NC} / ${HUMAN_MEM_ALL}"
    echo -e "    Swap usage: ${SWAP_COLOR}${HUMAN_SWAP_TAKE}${NC} / ${HUMAN_SWAP_ALL}"
    echo ""
    echo "    System load: ${SYS_LOAD} / ${CPU_CORES}.00"
    echo -e "    CPU Temperature: ${CPU_COLOR}${CPU_TEMPERATURE}${NC}"
    echo ""
    echo -n "    Usage of:"
        echo -e " ${DISKS_DONE[0]}"

    while [ "${DISK_MASSIVE}" -le "${DISK_FOUND_IN_MASSIVE}" ]; do

        echo -e "              ${DISKS_DONE[DISK_MASSIVE]}"
        ((DISK_MASSIVE = DISK_MASSIVE + 1))

    done

    echo ""
    echo -e "Updates: ${UPDATES}"

}

## Check memory

function memCheck() {

    ALL_MEM=$(free | sed "2q;d" | awk -F'[[:space:]]*' '{print $2}')
    TAKE_MEM=$(free | sed "2q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_MEM_TAKE=$(free -h | sed "2q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_MEM_ALL=$(free -h | sed "2q;d" | awk -F'[[:space:]]*' '{print $2}')

    ((HALF_MEM = ALL_MEM / 2))
    ((QUARTER_MEM_TMP = ALL_MEM / 4))
    ((QUARTER_MEM = ALL_MEM - QUARTER_MEM_TMP))

    if [ "${TAKE_MEM}" -lt "${QUARTER_MEM}" ] && [ "${TAKE_MEM}" -gt "${HALF_MEM}" ]; then

        MEM_COLOR='\033[33m';

    elif [ "${TAKE_MEM}" -gt "${QUARTER_MEM}" ]; then

        MEM_COLOR='\033[31m';

    else

        MEM_COLOR='\033[92m';

    fi

}

## Check swap

function swapCheck() {

    ALL_SWAP=$(free | sed "3q;d" | awk -F'[[:space:]]*' '{print $2}')
    TAKE_SWAP=$(free | sed "3q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_SWAP_TAKE=$(free -h | sed "3q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_SWAP_ALL=$(free -h | sed "3q;d" | awk -F'[[:space:]]*' '{print $2}')

    ((HALF_SWAP = ALL_SWAP / 2))
    ((QUARTER_SWAP_TMP = ALL_SWAP / 4))
    ((QUARTER_SWAP = ALL_SWAP - QUARTER_SWAP_TMP))

    if [ "${TAKE_SWAP}" -lt "${QUARTER_SWAP}" ] && [ "${TAKE_SWAP}" -gt "${HALF_SWAP}" ]; then

        SWAP_COLOR='\033[33m';

    elif [ "${TAKE_SWAP}" -gt "${QUARTER_SWAP}" ]; then

        SWAP_COLOR='\033[31m';

    else

        SWAP_COLOR='\033[92m';

    fi

}

## Check disk space

function disksCheck() {

    DISK_MASSIVE=0
    DISK_STR=1

    while true; do

        DISK_NAME=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $1}' | sed "${DISK_STR}q;d")

        if [ -n "${DISK_NAME}" ]; then

            DISKS[DISK_MASSIVE]="${DISK_NAME}"
            DISK_SPACE_ALL[DISK_MASSIVE]=$(df | grep /dev/sd | awk -F'[[:space:]]*' '{print $2}' | sed "${DISK_STR}q;d")
            DISK_SPACE_TAKE[DISK_MASSIVE]=$(df | grep /dev/sd | awk -F'[[:space:]]*' '{print $3}' | sed "${DISK_STR}q;d")

            DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $2}' | sed "${DISK_STR}q;d")
            DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $3}' | sed "${DISK_STR}q;d")

            DISK_MOUNT_NAME[DISK_MASSIVE]=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $6}' | sed "${DISK_STR}q;d")

            DISK_FOUND_IN_MASSIVE="${DISK_MASSIVE}"
            (("DISK_MASSIVE = DISK_MASSIVE + 1"))
            (("DISK_STR = DISK_STR + 1"))

            continue;
            
        else

            break;

        fi

    done

    DISK_MASSIVE=0

    while [ "${DISK_MASSIVE}" -le "${DISK_FOUND_IN_MASSIVE}" ]; do

        ((DISK_SPACE_HALF[DISK_MASSIVE] = DISK_SPACE_ALL[DISK_MASSIVE] / 2))
        ((DISK_SPACE_QUARTER_TMP[DISK_MASSIVE] = DISK_SPACE_ALL[DISK_MASSIVE] / 4))
        ((DISK_SPACE_QUARTER[DISK_MASSIVE] = DISK_SPACE_ALL[DISK_MASSIVE] - DISK_SPACE_QUARTER_TMP[DISK_MASSIVE]))

        if [ "${DISK_SPACE_TAKE[DISK_MASSIVE]}" -lt "${DISK_SPACE_QUARTER[DISK_MASSIVE]}" ] && [ "${DISK_SPACE_TAKE[DISK_MASSIVE]}" -gt "${DISK_SPACE_HALF[DISK_MASSIVE]}" ]; then

            DISK_COLOR='\033[33m';
            DISKS_DONE[DISK_MASSIVE]="${DISKS[DISK_MASSIVE]} (${DISK_MOUNT_NAME[DISK_MASSIVE]}): ${DISK_COLOR}${DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]}${NC} / ${DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]}"

        elif [ "${DISK_SPACE_TAKE[DISK_MASSIVE]}" -gt "${DISK_SPACE_QUARTER[DISK_MASSIVE]}" ]; then

            DISK_COLOR='\033[31m';
            DISKS_DONE[DISK_MASSIVE]="${DISKS[DISK_MASSIVE]} (${DISK_MOUNT_NAME[DISK_MASSIVE]}): ${DISK_COLOR}${DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]}${NC} / ${DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]}"

        else

            DISK_COLOR='\033[92m';
            DISKS_DONE[DISK_MASSIVE]="${DISKS[DISK_MASSIVE]} (${DISK_MOUNT_NAME[DISK_MASSIVE]}): ${DISK_COLOR}${DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]}${NC} / ${DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]}"

        fi

        ((DISK_MASSIVE = DISK_MASSIVE + 1))

    done

}

## Check updates

function updateList() {

    source /etc/os-release
    OS_ID="${ID}"

    echo "Just a second: Preparation of the machine..."
    echo ""
    echo "Logs:"

    if ! [ -d /tmp/.serverincolour ]; then

        mkdir /tmp/.serverincolour;

    fi

    if [ "${OS_ID}" == "ubuntu" ] || [ "${OS_ID}" == "debian" ] || [ "${OS_ID}" == "raspbian" ]; then

        echo -n 'UPDATES="' > "/tmp/.serverincolour/updates" && sudo apt update | tail -q -n1 >> "/tmp/.serverincolour/updates" && echo -n '"' >> "/tmp/.serverincolour/updates";

	elif [ "${OS_ID}" == "fedora" ] || [ "${OS_ID}" == "oracle" ]; then

		echo -n 'UPDATES="' > "/tmp/.serverincolour/updates" && sudo dnf update | tail -q -n1 >> "/tmp/.serverincolour/updates" && echo -n '"' >> "/tmp/.serverincolour/updates";

	elif [ "${OS_ID}" == "centos" ] || [ "${OS_ID}" == "almalinux" ] || [ "${OS_ID}" == "rocky" ]; then

		echo -n 'UPDATES="' > "/tmp/.serverincolour/updates" && sudo yum update | tail -q -n1 >> "/tmp/.serverincolour/updates" && echo -n '"' >> "/tmp/.serverincolour/updates";

	elif [ "${OS_ID}" == "arch" ]; then

		UPDATES="${ORANGE}N/A - Not available in ArchLinux yet.${NC}";

	fi

    tput reset

}

## Check internet connection and go to functions

ping -i 0.1 -c 1 8.8.8.8

if [ "${?}" == "2" ]; then

    tput reset;

    UPDATES="${ORANGE}N/A - No internet connection${NC}";

    memCheck;
    swapCheck;
    disksCheck;
    loginPage;

else

    tput reset;

    updateList;
    memCheck;
    swapCheck;
    disksCheck;
    loginPage;

fi
