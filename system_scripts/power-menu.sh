#!/usr/bin/env bash

op=$( echo -e " Poweroff\n Reboot\n󱉚 Hibernate\n Suspend\n Lock\n Logout" | wofi -i --dmenu | awk '{print tolower($2)}' )

case $op in 
        poweroff)
                ;&
        reboot)
                systemctl $op
                ;;
        hibernate)
                # hyprlock & sleep 3 && systemctl $op
                exec /etc/nixos/system_scripts/swaylockwp.sh & sleep 3 && systemctl $op
                ;;
        suspend)
                # hyprlock & sleep 3 && systemctl $op
                exec /etc/nixos/system_scripts/swaylockwp.sh & sleep 3 && systemctl $op
                ;;
        lock)
                # hyprlock
                exec /etc/nixos/system_scripts/swaylockwp.sh
                ;;
        logout)
                # hyprctl dispatch exit
                niri msg action quit
                ;;
esac
