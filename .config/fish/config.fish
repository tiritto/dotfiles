
# Aliases
alias ll 'ls --almost-all --color --format=verbose --human-readable --literal --time-style=long-iso'
alias ls yc'ls --color=auto -A'
alias grep='gre                 p --color=auto'
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias less="less -R"

alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'
alias .....='cd .....'

alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Starship
starship init fish | source