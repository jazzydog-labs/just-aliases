# System mode aliases
# System administration and maintenance aliases

# System administration
alias sudo="sudo"
alias su="su"
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias top="htop"
alias ps="ps aux"

# Package management (macOS)
alias brew="brew"
alias brewup="brew update && brew upgrade"
alias brewclean="brew cleanup"

# Network
alias myip="curl ifconfig.me"
alias ports="netstat -tulanp"
alias ping="ping -c 5"
alias traceroute="traceroute"

# File operations
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias mkdir="mkdir -p"
alias chmod="chmod"
alias chown="chown"

# System monitoring
alias mem="free -h"
alias disk="df -h"
alias cpu="top -o cpu"
alias load="uptime"

# Process management
alias psa="ps aux"
alias psg="ps aux | grep"
alias killall="killall"

echo "🖥️ System mode loaded"

# Package management
alias outdated='brew outdated'

# System information
alias space='du -sh * | sort -hr'

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

# Directory shortcuts
alias home='cd ~'
alias root='cd /'
alias etc='cd /etc'
alias tmp='cd /tmp'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop' 