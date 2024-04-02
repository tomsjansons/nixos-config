#!/usr/bin/env bash

op=$( echo -e " Poweroff\n Reboot\n󱉚 Hibernate\n Suspend\n Lock\n Logout" | wofi -i --dmenu | awk '{print tolower($2)}' )

case $op in 
        poweroff)
                ;&
        reboot)
                systemctl $op
                ;;
        hibernate)
                # hyprlock & sleep 2 && systemctl $op
                systemctl $op && hyprlock
                ;;
        suspend)
                # hyprlock & sleep 2 && systemctl $op
                systemctl $op && hyprlock
                ;;
        lock)
		hyprlock
                ;;
        logout)
                hyprctl dispatch exit
                ;;
esac
