# System mode aliases
# System administration and maintenance aliases

# Package management
alias update='brew update && brew upgrade'
alias cleanup='brew cleanup'
alias outdated='brew outdated'

# System information
alias cpu='top -l 1 | head -n 10'
alias mem='top -l 1 | head -n 4 | tail -n 1'
alias disk='df -h'
alias space='du -sh * | sort -hr'

# Process management
alias psa='ps aux'
alias psg='ps aux | grep'
alias meminfo='vm_stat'
alias load='uptime'

# Network utilities
alias pingg='ping google.com'
alias speed='speedtest-cli'
alias wifi='networksetup -setairportpower en0'
alias wifion='networksetup -setairportpower en0 on'
alias wifioff='networksetup -setairportpower en0 off'

# File operations
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Directory shortcuts
alias home='cd ~'
alias root='cd /'
alias etc='cd /etc'
alias tmp='cd /tmp'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop' 