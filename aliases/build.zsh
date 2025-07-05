# build mode aliases
# Add your aliases here:
# alias example='echo hello'

# Build mode aliases - for managing just-aliases itself

# Just-aliases management
alias jb="just build"
alias js="just source"
alias jall="just all"
alias jswitch="just switch"
alias jlist="just list"
alias jcurrent="just current"
alias jclear="just clear"
alias jhelp="just help"

# Global just-aliases commands
alias gjb="just -f ~/.just-aliases/justfile build"
alias gjs="just -f ~/.just-aliases/justfile source"
alias gjall="just -f ~/.just-aliases/justfile all"
alias gjswitch="just -f ~/.just-aliases/justfile switch"
alias gjlist="just -f ~/.just-aliases/justfile list"
alias gjcurrent="just -f ~/.just-aliases/justfile current"
alias gjclear="just -f ~/.just-aliases/justfile clear"
alias gjhelp="just -f ~/.just-aliases/justfile help"

# Quick navigation
alias ja="cd ~/dev/jazzydog-labs/foundry/just-aliases"
alias jadir="cd ~/dev/jazzydog-labs/foundry/just-aliases"
alias jaglobal="cd ~/.just-aliases"

echo "🔨 Build mode loaded - just-aliases management ready"