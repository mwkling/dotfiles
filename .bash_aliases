alias ve='python3 -m venv venv'
alias va='source venv/bin/activate'
alias g='git'
alias glog='git log --graph'
# alias fd=fdfind
alias gopen='hub browse'
alias ..='cd ..'
alias ...='cd `git rev-parse --show-toplevel`'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ll='ls -alF'

# Custom shell functions
for f in ~/.bash_functions.d/*.sh; do [ -r "$f" ] && source "$f"; done
