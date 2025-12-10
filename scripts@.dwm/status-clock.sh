#!/bin/bash

PREV_STATUS=""

while true; do
    # --- Time ---
    TIME=$(date '+%H:%M')

    # --- Date ---
    DATE=$(date '+%d %m %y')  # e.g., 20 07 24


    # --- Battery ---
    BAT_PATH=/sys/class/power_supply/BAT0
    if [ -d "$BAT_PATH" ]; then
        CAP=$(cat $BAT_PATH/capacity)
        STATUS=$(cat $BAT_PATH/status)
        case $STATUS in
            Charging) SYMBOL="C" ;;
            Discharging) SYMBOL="D" ;;
            Full) SYMBOL="F" ;;
            *) SYMBOL="?" ;;
        esac
        BAT="$SYMBOL $CAP%"
    else
        BAT="AC"
    fi

    # --- Wi-Fi ---
    WIFI=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
    [ -z "$WIFI" ] && WIFI="No Wi-Fi"

    # --- RAM (MB, excluding cache and buffers) ---
    MEM_TOTAL_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    MEM_FREE_KB=$(grep MemFree /proc/meminfo | awk '{print $2}')
    BUFFERS_KB=$(grep Buffers /proc/meminfo | awk '{print $2}')
    CACHED_KB=$(grep '^Cached:' /proc/meminfo | awk '{print $2}')
    SRECLAIMABLE_KB=$(grep SReclaimable /proc/meminfo | awk '{print $2}')

    MEM_USED_KB=$((MEM_TOTAL_KB - MEM_FREE_KB - BUFFERS_KB - CACHED_KB - SRECLAIMABLE_KB))
    MEM_USED_MB=$((MEM_USED_KB / 1024))
    MEM_TOTAL_MB=$((MEM_TOTAL_KB / 1024))

    RAM="${MEM_USED_MB}MB/${MEM_TOTAL_MB}MB"

    # --- Build status line ---
    STATUS_STR="Wi-Fi: $WIFI | $RAM | Bat: $BAT | $DATE | $TIME"

    # Update bar only if changed
    if [ "$STATUS_STR" != "$PREV_STATUS" ]; then
        xsetroot -name "$STATUS_STR"
        PREV_STATUS="$STATUS_STR"
    fi

    sleep 5
done

