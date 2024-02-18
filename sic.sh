#!/bin/bash

## ServerInColour v1.0
## Make your home page colorful and readable!
##
## Repository: https://github.com/medowic/serverincolour

tput reset
NC='\033[0m'

function homePage() {

    tput reset

    # shellcheck disable=SC1091
    source /etc/os-release

    echo "Welcome to ${PRETTY_NAME} ($(uname -mr))"
    echo ""
    echo " * Home URL-page: ${HOME_URL}"
    echo " * Get help: ${SUPPORT_URL}"
    echo ""
    echo "System information as of $(date)"
    echo ""
    ## RAM and SWAP-area info:
    echo -e "    ${MEM_LINE}"
    echo -e "    ${SWAP_LINE}"
    echo ""
    echo "    ${SYS_LOAD_LINE}"

    if [ -n "${CPU_LINE}" ]; then
        echo -e "    ${CPU_LINE}";
        echo "";
    else
        echo "";
    fi

    ## Show disks:
    echo -n "    Usage of:"
        echo -e " ${DISKS_DONE[0]}"

    local DISK_MASSIVE=1
    while [ "${DISK_MASSIVE}" -le "${DISK_FOUND_IN_MASSIVE}" ]; do

        echo -e "              ${DISKS_DONE[DISK_MASSIVE]}"
        ((DISK_MASSIVE = DISK_MASSIVE + 1))

    done

    echo ""

    ## Show updates:
    if [ -f /tmp/serverincolour/updates.tmp ]; then
        # shellcheck disable=SC1091
        source /tmp/serverincolour/updates.tmp
        echo "${UPDATES}"
        echo ""
    fi

}

## Check CPU's cores and temperature
function cpuCheck() {

    # shellcheck disable=SC2002
    CPU_CORES=$(cat /proc/cpuinfo | grep -c 'processor')
    # shellcheck disable=SC2002
    CPU_LOAD=$(cat /proc/loadavg | cut -d ' ' -f1)

    SYS_LOAD_LINE="System load: ${CPU_LOAD} / ${CPU_CORES}.00"

    if [ -f /sys/devices/virtual/thermal/thermal_zone0/temp ]; then
        local THERMAL_ZONE="/sys/devices/virtual/thermal/thermal_zone0/temp";
    elif [ -f /sys/class/hwmon/hwmon/temp1_input ]; then
        local THERMAL_ZONE="/sys/class/hwmon/hwmon/temp1_input";
    else
        local THERMAL_ZONE="";
    fi

    if [ -n "${THERMAL_ZONE}" ]; then

        CPU_TEMPERATURE_TMP=$(cat ${THERMAL_ZONE});
        ((CPU_TEMPERATURE_TMP = CPU_TEMPERATURE_TMP / 100));
        CPU_TEMPERATURE=$(echo "${CPU_TEMPERATURE_TMP}" | sed -r 's/(.{1})$/.\1/');

        if [ ${CPU_TEMPERATURE_TMP} -gt 500 ] && [ ${CPU_TEMPERATURE_TMP} -lt 800 ]; then
            local CPU_COLOR='\033[33m';
        elif [ ${CPU_TEMPERATURE_TMP} -gt 800 ]; then
            local CPU_COLOR='\033[31m';
        else
            local CPU_COLOR='\033[92m';
        fi

        CPU_LINE="CPU Temperature: ${CPU_COLOR}${CPU_TEMPERATURE}${NC} С";

    fi

    unset CPU_LOAD CPU_CORES CPU_TEMPERATURE_TMP CPU_TEMPERATURE

}

## Check RAM
function memCheck() {

    ALL_MEM=$(free | sed "2q;d" | awk -F'[[:space:]]*' '{print $2}')
    TAKE_MEM=$(free | sed "2q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_MEM_TAKE=$(free -h | sed "2q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_MEM_ALL=$(free -h | sed "2q;d" | awk -F'[[:space:]]*' '{print $2}')

    ((HALF_MEM = ALL_MEM / 2))
    ((QUARTER_MEM = ALL_MEM / 4))
    ((QUARTER_MEM = ALL_MEM - QUARTER_MEM))

    if [ "${TAKE_MEM}" -lt "${QUARTER_MEM}" ] && [ "${TAKE_MEM}" -gt "${HALF_MEM}" ]; then
        local MEM_COLOR='\033[33m';
    elif [ "${TAKE_MEM}" -gt "${QUARTER_MEM}" ]; then
        local MEM_COLOR='\033[31m';
    else
        local MEM_COLOR='\033[92m';
    fi

    MEM_LINE="Mem usage: ${MEM_COLOR}${HUMAN_MEM_TAKE}${NC} / ${HUMAN_MEM_ALL}";
    unset ALL_MEM TAKE_MEM HUMAN_MEM_TAKE HUMAN_MEM_ALL HALF_MEM QUARTER_MEM

}

## Check SWAP-area
function swapCheck() {

    ALL_SWAP=$(free | sed "3q;d" | awk -F'[[:space:]]*' '{print $2}')
    TAKE_SWAP=$(free | sed "3q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_SWAP_TAKE=$(free -h | sed "3q;d" | awk -F'[[:space:]]*' '{print $3}')
    HUMAN_SWAP_ALL=$(free -h | sed "3q;d" | awk -F'[[:space:]]*' '{print $2}')

    ((HALF_SWAP = ALL_SWAP / 2))
    ((QUARTER_SWAP = ALL_SWAP / 4))
    ((QUARTER_SWAP = ALL_SWAP - QUARTER_SWAP))

    if [ "${TAKE_SWAP}" -lt "${QUARTER_SWAP}" ] && [ "${TAKE_SWAP}" -gt "${HALF_SWAP}" ]; then
        local SWAP_COLOR='\033[33m';
    elif [ "${TAKE_SWAP}" -gt "${QUARTER_SWAP}" ]; then
        local SWAP_COLOR='\033[31m';
    else
        local SWAP_COLOR='\033[92m';
    fi

    SWAP_LINE="Swap usage: ${SWAP_COLOR}${HUMAN_SWAP_TAKE}${NC} / ${HUMAN_SWAP_ALL}"
    unset ALL_SWAP TAKE_SWAP HUMAN_SWAP_TAKE HUMAN_SWAP_ALL HALF_SWAP QUARTER_SWAP

}

## Check disk space
function disksCheck() {

    DISK_MASSIVE=0
    DISK_STR=1

    while [ -n "$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $1}' | sed "${DISK_STR}q;d")" ]; do

        DISK_NAME=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $1}' | sed "${DISK_STR}q;d")

        DISKS[DISK_MASSIVE]="${DISK_NAME}"

        DISK_SPACE_ALL[DISK_MASSIVE]=$(df | grep /dev/sd | awk -F'[[:space:]]*' '{print $2}' | sed "${DISK_STR}q;d")
        DISK_SPACE_TAKE[DISK_MASSIVE]=$(df | grep /dev/sd | awk -F'[[:space:]]*' '{print $3}' | sed "${DISK_STR}q;d")

        DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $2}' | sed "${DISK_STR}q;d")
        DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $3}' | sed "${DISK_STR}q;d")

        DISK_MOUNT_NAME[DISK_MASSIVE]=$(df -h | grep /dev/sd | awk -F'[[:space:]]*' '{print $6}' | sed "${DISK_STR}q;d")

        DISK_FOUND_IN_MASSIVE="${DISK_MASSIVE}"
        ((DISK_MASSIVE = DISK_MASSIVE + 1))
        ((DISK_STR = DISK_STR + 1))

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
            DISKS_DONE[DISK_MASSIVE]="${DISK_MOUNT_NAME[DISK_MASSIVE]} (${DISKS[DISK_MASSIVE]}): ${DISK_COLOR}${DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]}${NC} / ${DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]}"
        else
            DISK_COLOR='\033[92m';
            DISKS_DONE[DISK_MASSIVE]="${DISK_MOUNT_NAME[DISK_MASSIVE]} (${DISKS[DISK_MASSIVE]}): ${DISK_COLOR}${DISK_SPACE_TAKE_HUMAN[DISK_MASSIVE]}${NC} / ${DISK_SPACE_ALL_HUMAN[DISK_MASSIVE]}"
        fi

        ((DISK_MASSIVE = DISK_MASSIVE + 1))

    done

    unset DISKS DISK_SPACE_ALL DISK_SPACE_TAKE DISK_SPACE_ALL_HUMAN DISK_SPACE_TAKE_HUMAN \
     DISK_MOUNT_NAME DISK_MASSIVE DISK_STR DISK_SPACE_HALF \
     DISK_SPACE_QUARTER DISK_SPACE_QUARTER_TMP DISK_COLOR

}

## Go to functions
memCheck;
swapCheck;
disksCheck;
cpuCheck;
homePage;

unset MEM_LINE SWAP_LINE SYS_LOAD_LINE CPU_LINE DISKS_DONE DISK_FOUND_IN_MASSIVE DISK_MASSIVE NC
