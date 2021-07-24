#!/usr/bin/env bash

xset m 30 1 &
/usr/bin/setxkbmap -option "ctrl:nocaps" &
xinput set-prop "TPPS/2 Elan TrackPoint" "libinput Natural Scrolling Enabled" 1
xinput set-prop "Synaptics TM3418-002" "libinput Accel Speed" 0.5

sudo /home/mgajewskik/bin/set-thermals.sh && notify-send 'Thermals set'
feh --bg-fill --no-fehbg ~/Pictures/Wallpapers/firewatch_6.jpg && notify-send 'Wallpaper reset'

systemctl --user start greenclip.service

picom --config ~/.config/picom.conf &
udiskie --tray &
nm-applet &
blueman-applet &
dunst &
megasync &
