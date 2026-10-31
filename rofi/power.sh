#!/usr/bin/env bash
# Update and power options for the $mod+space launcher (rofi script mode, combined with apps).
# rofi runs this with no args to list the entries, then again with the chosen one.
# Each row gets a real icon (from ./icons) so its text lines up with the app names.

icons=~/.config/rofi/icons

case $1 in
    Update)   setsid -f kitty --title "System update" ~/.config/rofi/update.sh >/dev/null 2>&1 ;;
    Lock)     setsid -f ~/.config/i3/lock.sh >/dev/null 2>&1 ;;
    Logout)   i3-msg exit >/dev/null ;;
    Suspend)  systemctl suspend ;;
    Reboot)   systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
    *)
        for row in Update:update Shutdown:shutdown Reboot:reboot Lock:lock Logout:logout Suspend:suspend; do
            printf '%s\0icon\x1f%s\n' "${row%%:*}" "$icons/${row##*:}.png"
        done
        ;;
esac
