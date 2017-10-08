#set -g mouse-utf8 on
set -g mouse on
bind -n WheelUpPane   select-pane -t= \; copy-mode -e \; send-keys -M
bind -n WheelDownPane select-pane -t= \;                 send-keys -M

set -g history-limit 30000
setw -g alternate-screen on
set -g status off
