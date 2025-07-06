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