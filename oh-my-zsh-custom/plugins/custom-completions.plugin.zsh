launch_in_bg=(gvim gvimdiff firefox vlc cvlc chromium mirage zathura)

lbg() {
  $1 ${@:2} >> /dev/null 2> /dev/null&!; 
}

for program in $launch_in_bg
  alias $program="lbg $program";

whichpkg() {
  pacman -Qo $(which $* | grep -v "not found")
}

_whichpkg() {
  _arguments \
    '*:command: _command_names -e'
}

_lbg() {
  _arguments \
    '(-):command: _command_names -e' \
    '*::args: _normal'
}

# compdefs
compdef _lbg lbg
compdef _whichpkg whichpkg
