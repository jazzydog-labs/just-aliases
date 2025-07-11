# Bootstrap Aliases - Essential aliases only
# This file loads first in the modular custom script system

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

# bootstrapping helpers
alias sz="source ~/.zshrc"

alias ld="loom details"
alias l="loom"

# editing helpers
alias cu="cursor" # we use c for clear

if alias | grep -q "gg"; then
    unalias gg
fi


# development helpers
alias lp="loom sync --push"
# g function with completion is now defined in 002_functions.bootstrap.zsh
# if alias | grep -q "g"; then
#     unalias g
# fi
# testing helpers
alias jt="just test"
alias jd="just demo"
alias r="glow"
alias t='tree -I "__pycache__|node_modules|htmlcov"'
alias j="just"
alias lt="loom just test-silent"

# genesis helpers
alias genesis="poetry run genesis"


# copy/paste helpers
alias p="pbpaste"
alias c="pbcopy"



### tools
alias n="nvim"
alias b="bat"
alias t="tree -I 'node_modules'"
# tree no report/formatting
alias tn="t --noreport -i -f"
# tree no report/formatting, files only, stripping out "*" from executable files
alias tnf='tn -F | grep -vE ".*\/$" | sed "s/\*$//"'

### history
alias h="history"
# history -tail
alias ht="history | tail"

### git
alias gs="git status --short --branch --show-stash"
alias glog='git log --oneline --decorate --graph --format="%C(auto)%h %C(green)|%C(auto) %<(12)%ad%C(green)|%C(auto) %s%d %C(reset)" --date=relative'
alias glogs="glog --stat"

### tmux
alias ta="tmux attach"
alias mux="tmuxinator"

### helper functions
# short date 
alias sd="date +%Y-%m-%d"