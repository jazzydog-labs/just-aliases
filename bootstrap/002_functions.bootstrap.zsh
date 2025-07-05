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