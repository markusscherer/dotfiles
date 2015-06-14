# general browsing
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ....='cd ../../..'

# Add bookmarks for interessting directories
for i in /home/markus/studium/ss15/*; # explicit path for root compability
  alias "$(basename $i)=cd $i"

unset i #viele jahre war dies ein bug!
  
alias dow='cd ~/downloads/browser/'

# greping stuff
alias ofgrep="lsof | grep"
alias plgrep="mpc playlist | cat -n | grep -i"
alias grepgrep='alias | grep grep | sed "s/=/\t/g"'
alias histgrep='history | grep -i'
alias gril='grep -ril'
alias gri='grep -rin'
alias gi='grep -i'

# convenience functions
alias fu='sudo $( fc -ln -1)'
alias e=extract
#alias o=xdg-open
alias o='lbg xdg-open'
alias tailf='tail -f'
alias sby='sudo systemctl suspend; slock' #'echo nein' #'systemctl suspend' #'sudo pm-suspend'  #'echo mem > /sys/power/state'
alias fav='mpc current -f "%file%" >> ~/.mpd/playlists/favs.m3u'
alias mfnl='mpc current -f "%file%" >> ~/.mpd/playlists/mfnl.m3u'
alias brok='mpc current >> ~/broken'

alias wcc='wc -c'
alias wcl='wc -l'
alias wcw='wc -w'

alias dfh='df -h'
alias duh='du -h'
alias dub='du -b'

alias mvi='mv -i'
alias cpi='cp -i'

alias disnt='dis; nt && exit'

# supress error on non-matching glob
setopt null_glob

#vim integration
alias gt='gvim --remote-send "gt<RETURN>"'
alias gT='gvim --remote-send "gT<RETURN>"'
alias v='gvim --remote-tab-silent'
alias sv='sudo gvim --remote-tab-silent'
alias reloadvimrc='gvim --remote-send ":source ~/.vimrc<RETURN>"'

alias zshconf='vim -p ~/.oh-my-zsh/custom/aliases.zsh \
                      ~/.oh-my-zsh/custom/functions.zsh \
                      ~/.zshrc \
                      && source ~/.zshrc'
alias vimconf='vim ~/.vimrc && reloadvimrc'
alias todo='vim ~/docs/vimwiki/TODO.wiki'
alias wiki='vim ~/docs/vimwiki/index.wiki'
alias vok='vim ~/docs/vimwiki/vokabeln.wiki +$'
alias idee='vim ~/docs/vimwiki/ultimativ\ geniale\ ideen,\ die\ verwirklichung\ bedürfen.wiki'
ewhich() {vim $(which $1)}

alias ddprog='killall -SIGUSR1 dd'
alias beep='yes "ffdffffz" | head -600 | tr -d '\n' | aplay 2> /dev/null'

# info
alias hostip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'
alias lsop='netstat -tlnp'

# override standard behaviour
alias scrot="scrot -e 'mv "'$f'" ~/bilder/screenshots'"
alias shutdown='killall mpd; systemctl poweroff'
alias reboot='sudo reboot'
alias su='sudo su'
alias rehash='rehash && source ~/.zshrc'
alias eclipse='GTK2_RC_FILES=/usr/share/themes/Radiance/gtk-2.0/gtkrc:/home/markus/.gtkrc-eclipse /home/markus/bin/eclipse/eclipse'
alias nt='lbg urxvt'

# arch linux
alias pacfil='pacman -Ql'
whichpkg() {
  pacman -Qo $(which $* | grep -v "not found")
}
_whichpkg() {
  _arguments \
    '*:command: _command_names -e'
}

launch_in_bg=(gvim gvimdiff firefox vlc cvlc chromium mirage zathura)

lbg() {
  $1 ${@:2} >> /dev/null 2> /dev/null&!; 
}

_lbg() {
  _arguments \
    '(-):command: _command_names -e' \
    '*::args: _normal'
}

for program in $launch_in_bg
  alias $program="lbg $program";

# development
alias waf="./waf-1.7.0"

# compdefs
compdef _lbg lbg
compdef _whichpkg whichpkg

fzf-music-widget() {
  mpc listall | fzf -m | mpc insert --quiet
  zle redisplay
}

zle      -N  fzf-music-widget
bindkey '^N' fzf-music-widget
