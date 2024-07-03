#! /bin/bash

INTERVAL=30

MIN_BAT=10
MAX_BAT=80
CRIT_BAT=2

# POWER_UNPLUG=/usr/share/sounds/freedesktop/stereo/power-unplug.oga
# POWER_PLUG=/usr/share/sounds/freedesktop/stereo/power-plug.oga

set -eu

get_plugged_state(){
    echo $(cat /sys/bus/acpi/drivers/battery/*/power_supply/BAT?/status)
}

get_bat_percent(){
    echo $(acpi|grep -Po "[0-9]+(?=%)")
}

# notify_sound(){
#     if [[ -n $1 ]]; then
#         paplay ${1}
#     fi
# }

while true ; do

    if [ $(get_bat_percent) -le ${MIN_BAT} ]; then 
        if [[ $(get_plugged_state) = "Discharging" ]]; then 
            if [ $(get_bat_percent) -ge ${CRIT_BAT} ]; then
                notify-send -u critical -i /etc/nixos/system_scripts/icons8-android-l-battery-64.png "Battery below ${MIN_BAT}" 
                # notify_sound $POWER_PLUG
            fi
            
            if [ $(get_bat_percent) -le ${CRIT_BAT} ]; then
                notify-send -u critical -i /etc/nixos/system_scripts/icons8-sleep-50.png "Battery critical - hibernating" 
                exec /etc/nixos/system_scripts/swaylockwp.sh &
                sleep 2
                systemctl hibernate
            fi
        fi
    fi
    if [ $(get_bat_percent) -ge ${MAX_BAT} ]; then 
        if ! [ -f /tmp/battery-check-marker ]; then
            if [[ $(get_plugged_state) = "Charging" ]]; then 
                notify-send -u critical -i /etc/nixos/system_scripts/icons8-full-battery-64.png "Battery above ${MAX_BAT}"
                touch /tmp/battery-check-marker
                # notify_sound $POWER_UNPLUG
            fi
        fi
    fi

    if [[ $(get_plugged_state) = "Discharging" ]]; then 
        rm /tmp/battery-check-marker
    fi

    sleep ${INTERVAL} 
done
