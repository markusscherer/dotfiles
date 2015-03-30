# Path to your oh-my-zsh configuration.
ZSH=/home/markus/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="mrks"
[[ $TERM = "linux" ]] && ZSH_THEME="walters" #if no unicode fonts are available
[[ $TERM = "linux" ]] || TERM=xterm          #fix remote connections that don't
                                             #know rxvt-unicode-256color

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git archlinux nyan extract zathura haskell catimg colored-man)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export EDITOR=vim
export PAGER=less #/usr/local/bin/vimpager

eval $(dircolors -b /home/markus/.dircolors)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' mpd-music-directory /home/markus/music/

HISTFILE=~/.zsh_history
HISTSIZE=40000
SAVEHIST=40000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space

autoload zmv

# Autosuggestions
#source /home/markus/.zsh-autosuggestions/autosuggestions.zsh
#
## Enable autosuggestions automatically
#zle-line-init() {
#    zle autosuggest-start
#}
#zle -N zle-line-init
#
## use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
## zsh-autosuggestions is designed to be unobtrusive)
#bindkey '^T' autosuggest-toggle
#AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=4'
