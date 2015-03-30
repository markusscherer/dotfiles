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

synclient VertTwoFingerScroll=1
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1

nitrogen --restore &
./.config/trayer &
./code/others/xmobar/.cabal-sandbox/bin/xmobar &

setxkbmap -layout us,ru -variant altgr-intl,phonetic -option grp:caps_toggle
exec xmonad
