#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -n $(xrandr | grep "HDMI1 connected") ]] && .screenlayout/monitor-left.sh

synclient VertTwoFingerScroll=1
synclient VertTwoFingerScroll=1
ynclient HorizTwoFingerScroll=1

nitrogen --restore &
./.config/trayer &
./code/others/xmobar/.cabal-sandbox/bin/xmobar &

[[ -n $(xrandr | grep "HDMI1 connected") ]] && \
    ./code/others/xmobar/.cabal-sandbox/bin/xmobar -x 1 ~/.dotfiles/xmobarrc-secondary &

setxkbmap -layout us,ru -variant altgr-intl,phonetic -option grp:caps_toggle
exec xmonad
