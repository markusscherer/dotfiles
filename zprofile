#add paths
export PATH=/home/markus/bin:/home/markus/.cabal/bin:$PATH
export PATH=$PATH:/home/markus/.go/bin
export PATH=$PATH:/opt/matlab/bin/
export PATH=$PATH:/opt/android-sdk/tools
export PATH=$PATH:/opt/android-sdk/platform-tools
export PATH=/opt/sun-java6/bin:$PATH

export XDG_CACHE_HOME=/home/markus/.cache
export GOPATH=$HOME/.go/

#envfile="$HOME/.gnupg/gpg-agent.env"
#if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
#    eval "$(cat "$envfile")"
#else
#    [[ -z "$TMUX" ]] && eval "$(gpg-agent --daemon --write-env-file "$envfile")"
#fi
#export GPG_AGENT_INFO  # the env file does not contain the export statement


[[ -z "$TMUX" ]] && eval $(ssh-agent)

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi
