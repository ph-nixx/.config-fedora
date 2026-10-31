#!/usr/bin/env bash
# Restart cleanly on i3 reload/restart
killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.2; done
polybar omarchy >>/tmp/polybar.log 2>&1 & disown
