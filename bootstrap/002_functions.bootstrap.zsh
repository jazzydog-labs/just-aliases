# Bootstrap Functions - Essential functions only
# This file loads second in the modular custom script system

# Just-aliases bootstrap function
# stands for just-aliases all
function jall() {
    local ja_dir="$HOME/dev/jazzydog-labs/foundry/just-aliases"
    local current_dir=$(pwd)
    
    if [[ ! -d "$ja_dir" ]]; then
        echo "❌ Just-aliases directory not found at $ja_dir"
        return 1
    fi
    
    if [[ $(get_config "expert-mode") == "false" ]]; then
        echo "🚀 Bootstrapping just-aliases system..."
    fi
    
    # Change to just-aliases directory
    cd "$ja_dir"
    
    # Run bootstrap and reload shell
    just bootstrap && sz
    
    # Change back to original directory
    cd "$current_dir"
    
    if [[ $(get_config "expert-mode") == "false" ]]; then
        echo "✅ Just-aliases bootstrap complete"
    fi
}

# use yq to check some config flag from ~/.config/jazzydog-labs/.config.yaml
function get_config() {
    # get the attribute from the argument
    local attribute=$1
    # first check if the file exists
    if [[ -f ~/.config/jazzydog-labs/.config.yaml ]]; then
        # then get the attribute from the config file
        local value=$(yq ".$attribute" ~/.config/jazzydog-labs/.config.yaml)
        echo "$value"   
    else
        return 1
    fi
}

# Foundry bootstrap function
# stands for foundry bootstrap
function fb() {
    local fb_dir="$HOME/dev/jazzydog-labs/foundry/foundry-bootstrap"
    local current_dir=$(pwd)
    
    if [[ ! -d "$fb_dir" ]]; then
        echo "❌ Foundry-bootstrap directory not found at $fb_dir"
        return 1
    fi
    
    if [[ $(get_config "expert-mode") == "false" ]]; then
        echo "🚀 Bootstrapping foundry system..."
    fi
    
    # Change to foundry-bootstrap directory
    cd "$fb_dir"
    
    # Run bootstrap
    ./bootstrap.sh
    
    # Change back to original directory
    cd "$current_dir"
    
    if [[ $(get_config "expert-mode") == "false" ]]; then
        echo "✅ Foundry bootstrap complete"
    fi
}

# cru goes to jazzydog-labs/crucible, runs `./cru blueprint`, then changes back to the original directory
# follows the same pattern as foundry-bootstrap
function cru() {
    local cru_dir="$HOME/dev/jazzydog-labs/foundry/crucible"
    local current_dir=$(pwd)
    
    if [[ ! -d "$cru_dir" ]]; then
        echo "❌ Crucible directory not found at $cru_dir"
        return 1
    fi
    
    if [[ $(get_config "expert-mode") == "false" ]]; then
        echo "🚀 Running crucible blueprint..."
    fi
    
    # Change to crucible directory
    cd "$cru_dir"
    
    # Run bootstrap
    ./cru blueprint

    # Change back to original directory
    cd "$current_dir"
}

# Navigate to a loom project directory
# Usage: lg <project-name>
lg() { 
    # 1. get the project name from the argument
    local project_name=$1
    
    if [[ -z "$project_name" ]]; then
        # If no argument, run loom go and navigate to the returned directory
        local project_info=$(loom go 2>/dev/null)
        
        if [[ -z "$project_info" ]]; then
            echo "❌ Could not get project info from loom go"
            return 1
        fi
        
        # Extract directory to cd into
        local project_dir=$(echo "$project_info" | jq -r '.directory // .path // .cd_to // empty')
        
        if [[ -z "$project_dir" ]]; then
            echo "❌ Could not find project directory in JSON response"
            return 1
        fi
        
        # Extract user messages to display
        local user_message=$(echo "$project_info" | jq -r '.message // .user_message // .info // empty')
        if [[ -n "$user_message" ]]; then
            echo "💡 $user_message"
        fi
        
        # Extract context to show
        local context=$(echo "$project_info" | jq -r '.context // .status // .description // empty')
        if [[ -n "$context" ]]; then
            echo "📋 Context: $context"
        fi
        
        echo "🚀 Project directory: $project_dir"
        
        # cd to the project directory
        cd "$project_dir"
        
        # echo success
        echo "✅ Navigated to $project_dir"
        return 0
    fi
    
    echo "🚀 Navigating to $project_name"
    
    # Simply pass the project name to loom go and let it handle fuzzy finding
    local project_info=$(loom go "$project_name" 2>/dev/null)
    
    # 3. extract directory to cd into
    local project_dir=$(echo "$project_info" | jq -r '.directory // .path // .cd_to // empty')
    
    if [[ -z "$project_dir" ]]; then
        echo "❌ Could not find project directory in JSON response"
        return 1
    fi
    
    # 4. extract user messages to display
    local user_message=$(echo "$project_info" | jq -r '.message // .user_message // .info // empty')
    if [[ -n "$user_message" ]]; then
        echo "💡 $user_message"
    fi
    
    # 5. extract context to show
    local context=$(echo "$project_info" | jq -r '.context // .status // .description // empty')
    if [[ -n "$context" ]]; then
        echo "📋 Context: $context"
    fi
    
    echo "🚀 Project directory: $project_dir"
    
    # 6. cd to the project directory
    cd "$project_dir"
    
    # 7. echo success
    echo "✅ Navigated to $project_dir"
}



# Open TODO.md file in Cursor at git repo root (create if doesn't exist)
function todo() {
    # Get git repo root using git command
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    
    if [[ -z "$git_root" ]]; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    local readme_file="$git_root/TODO.md"
    
    # Create TODO.md if it doesn't exist
    if [[ ! -f "$readme_file" ]]; then
        echo "📝 Creating TODO.md at git root: $git_root"
        touch "$readme_file"
    else
        echo "📝 Opening existing TODO.md: $readme_file"
    fi
    
    # Open in Cursor
    cursor "$readme_file"
}

# ts stands for todo show, using:
function ts() {
    # get the current directory
    local current_dir=$(pwd)
    # run the rg command
    rg --line-number --context 2 --fixed-strings 'TODO:' "$current_dir"
}


# Navigate to a loom project directory with autocomplete
# Usage: g <project-name>
# This is a wrapper around lg that provides autocomplete for loom repos
function g() {
    lg "$@"
}

# Completion function for loom repos
function _g_completion() {
    local -a loom_repos
    loom_repos=(
        "riverrun"
        "panorama"
        "bill-of-materials"
        "just-aliases"
        "loom"
        "forge"
        "crucible"
        "vault"
        "ledger"
        "foundry-bootstrap"
    )
    
    _describe 'loom repos' loom_repos
}

# Initialize completion system and register the completion function
if [[ -n ${ZSH_VERSION-} ]]; then
    # Ensure completion system is loaded
    autoload -U compinit
    compinit -d ~/.zcompdump
    
    # Register the completion function
    compdef _g_completion g
fi