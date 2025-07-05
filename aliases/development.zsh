# Development mode aliases
# Common aliases for development work

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"
alias gco="git checkout"
alias gcb="git checkout -b"

# Directory navigation
alias dev='cd ~/dev'
alias proj='cd ~/projects'

# Common development commands
alias py="python"
alias py3="python3"
alias pip="pip3"
alias venv="python3 -m venv"
alias activate="source venv/bin/activate"

# Node.js development
alias npm="npm"
alias npx="npx"
alias node="node"

# Common development tools
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Just shortcuts
alias jb="just build"
alias js="just source"
alias jall="just all"

# Editor shortcuts
alias v='vim'
alias n='nvim'
alias c='code .'

# Process management
alias psg='ps aux | grep'
alias killp='kill -9'

# Network
alias myip='curl ifconfig.me'
alias ports='netstat -tulanp'

echo "🎯 Development mode loaded" 