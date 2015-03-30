PROMPT='%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%(!.✱.❯) %{$fg_bold[cyan]%}%c $(git_prompt_info)%{$fg_no_bold[default]%}%'
RPROMPT='%{$fg_no_bold[blue]%}%~%{$fg[default]%}%'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git%{$reset_color%}:%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
