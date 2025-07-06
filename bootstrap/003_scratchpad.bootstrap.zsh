# Bootstrap Scratchpad - Non-essential helpers
# This file loads third in the modular custom script system

### SCRATCHPAD ###

# gch stands for git commit (with) header
# Usage: gch <commit-message>
# Adds all current changes and creates a commit with the provided message.
function gch() {
    # get the commit message from the argument
    local commit_message=$1
    # add all files to the commit
    git add .
    # create the commit
    git commit -m "$commit_message"
}

# Convenience alias to quickly commit with a message
alias gg='gch' 