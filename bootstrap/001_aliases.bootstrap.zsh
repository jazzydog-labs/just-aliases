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
if alias | grep -q "g"; then
    unalias g
fi
# testing helpers
alias jt="just test"
alias jd="just demo"
alias r="glow"
alias t='tree -I "__pycache__|node_modules|htmlcov"'
alias j="just"
alias lt="loom just test-silent"

# genesis helpers
alias genesis="poetry run genesis"