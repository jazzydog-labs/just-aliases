# Development mode aliases
# Common aliases for development work

# Git shortcuts
alias gstest='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gco='git checkout'
alias gcb='git checkout -b'

# Directory navigation
alias dev='cd ~/dev'
alias proj='cd ~/projects'

# Common development commands
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias tree='tree -I node_modules'

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