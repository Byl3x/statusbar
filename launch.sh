#!/bin/bash

# Colour names
WHITE=ffffff
GRAY=DCDCDC
YELLOW=FFD700
BLUE=1E90FF

IFS=$'\n'

function text { output+=$(echo -n '{"full_text": "'${1//\"/\\\"}'", "color": "#'${2-$WHITE}'", "separator": false, "separator_block_width": 1}, ') ;}


echo -e '{ "version": 1 }\n['
while :; do
    WINDOW=( $(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d\  -f5) _NET_WM_NAME WM_CLASS | sed 's/.*\ =\ "\|\",\ \".*\|"$//g;s/\\\"/"/g') )
    VOLUME=$(pamixer --get-volume)
    CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%" }'
    ) 
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    BATSTAT=$(cat /sys/class/power_supply/BAT0/status)
    RAM=$(awk '/MemTotal:/{total=$2}/MemAvailable:/{free=$2;print int(100-100/(total/free))}' /proc/meminfo)
    DATE=$(date +'%x %T')

    output=''
    text ${WINDOW[1]}\  $GRAY
    text ${WINDOW[0]}
    text " Vol:"$VOLUME"%"
    text ' ⚡' $YELLOW
    text "$BAT%: [$BATSTAT]"
    text ' CPU ' $GRAY
    text "$CPU"
    text ' RAM ' $GRAY
    text "$RAM%"
    text '  ' $BLUE
    text "$DATE"
    echo -e "[${output%??}],"
    sleep 0.25
done
