ndf() { 
  ext="${1##*.}"
  file=$(date +%Y-%m-%d-)$1 
  [[ -f template.$ext ]] || touch $file
  [[ -f template.$ext ]] && cp -i template.$ext $file
}

vdf() { 
  ext="${1##*.}"
  file=$(date +%Y-%m-%d-)$1 
  [[ -f template.$ext ]] || touch $file
  [[ -f template.$ext ]] && cp -i template.$ext $file
  v $file
}


alias f='cd $_'

casp() {
  pleasenot="thisstringwontappearinanysonglalalalalala"
  if [ -d $(pidof mpd) ]; then
    beet mpdstats > /dev/null 2> /dev/null &!
    mpd ~/.mpd/config
    mpc play > /dev/null 
  else
    mpc clear > /dev/null
    mpc listall | egrep -v $pleasenot | mpc add > /dev/null 
    mpc shuffle > /dev/null 
    mpc play > /dev/null 
    rm -f $HOME/.mpd/queue
  fi
}

swpf() {
  if [[ -f $1 && -f $2 ]]; then
    tmp=$(mktemp)
    mv $1 $tmp
    mv $2 $1
    mv $tmp $2
  fi
}

bkp() {
  cp $1{,.bkp}
}

urlencode() {
	perl -p -e 's/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
}

dis() {
  file=$(mktemp)
  disown 2> $file
  cmd=$(cat $file | cut -d \` -f 2| cut -d \' -f 1)
  echo $cmd
  eval $cmd
  rm $file
}

paste2() {
	if [ -f $1 ]; then
		case $1 in
			*.c|*.cpp|*.cc|*.h|*.hpp)  lang="cpp"         ;;
			*.css)                     lang="css"         ;;
			*.html|*.htm)              lang="html4strict" ;;
			*.java)                    lang="java"        ;;
			*.ini)                     lang="ini"         ;;
			*.lua)                     lang="lua"         ;;
			*.pl)                      lang="perl"        ;;
			*.php)                     lang="php"         ;;
			*.py)                      lang="python"      ;;
			*.rb)                      lang="ruby"        ;;
			*.sql)                     lang="mysql"       ;;
			*.xml)                     lang="xml"         ;;
			*)                         lang="text"        ;;
		esac
	else
		echo "'$1' is not a valid file"
		return
	fi
	echo -n "http://www.paste2.org"
	postdata="lang=$lang&description=&code="$(cat $1 | 
		urlencode | awk '{print $0"%0D%0A"}END{print "---"}' | 
		tr -d "\n" | sed 's/%0D%0A---$//g')"&parent=0"
	
	wget --post-data="$postdata" http://www.paste2.org/new-paste -S --header='Host: paste2.org' -q |& 
	grep Location |cut -d " " -f 4 
}

# Makes directory then moves into it
mcd() {
  mkdir -p -v $1
	cd $1
}

+x() {
  chmod +x $@ 2> /dev/null;
  [[ $? != 0 ]] && sudo chmod +x $@ || true;
}

777() {
  chmod 777 $@ 2> /dev/null;
  [[ $? != 0 ]] && sudo chmod 777 $@;
}

mb () {
  mv "$@" -t "$( (cd - && pwd)| tail -1)";
}

mpswo() {
  a=$(mpc outputs | grep enabled | cut -f 2 -d " " | head -1);  
  c=$(mpc outputs | wc -l);

  ((b = (($a%$c)+1)));

  mpc enable $b > /dev/null;
  mpc disable $a;
  mpc play > /dev/null
}

mpcalb() {
  mpc crop;
  album=$(mpc -f "%album%" current);
  mpc search album $album | mpc add;
  pos=$(mpc -f "%position%;%file%" playlist | grep "$(mpc -f "%file%" | head -1)" | cut -f 1 -d ";" | sed 1d);
  mpc move 1 $pos;
  mpc del $(($pos - 1));
  [[ $1 == "1" ]] && mpc play 1
}

mpcart() {
  mpc crop;
  artist=$(mpc -f "%artist%" current);
  mpc search artist $artist | mpc add;
  pos=$(mpc -f "%position%;%file%" playlist | grep "$(mpc -f "%file%" | head -1)" | cut -f 1 -d ";" | sed 1d);
  mpc move 1 $pos;
  mpc del $(($pos - 1));
  [[ $1 == "1" ]] && mpc play 1
}

mptop() {
  [[ $1 == "--help" ]] && echo "usage: mptop <length of list> <number of songs> <level of detail> <filter>" && return;
  top=${1:-20};
  songs=${2:-1000};
  field=$3;
  filter=${4:-cat};
  grep "played" $HOME/.mpd/log | tail -$songs | eval $filter | sed 's|Eigene Musik/||' | cut -d '"' -f 2 | 
  cut -d "/" -f 1-$field| sort | uniq -c | sort -rn | head -$top;
}

psum () {
  awk '{ SUM += $1} END { print SUM }'
}

ff() {
  find . -iname "*$1*"
}

#every command that starts with ":" gets sent to $VIMSERVER
command_not_found_handler () { 
  VIMSERVER=${VIMSERVER:-GVIM};
  if [[ "$@" == ":"* ]] then
    CMD="'$@<RETURN>'"
    #without eval it's somehow buggy
    eval gvim --remote-send $CMD --servername $VIMSERVER
  else 
    return 127;
  fi
}
