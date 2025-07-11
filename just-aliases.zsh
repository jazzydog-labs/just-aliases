# just-aliases - Modal alias system for Zsh
# 
# This file provides the shell integration for the modal alias system.
# Source this file in your .zshrc to enable the `ja` function.

# Active mode tracking variable
export __just_aliases_active_mode=""

# Get the directory where this script is located
JUST_ALIASES_DIR="${0:A:h}"

# Function to switch modes
function ja() {
    local mode_manager="$JUST_ALIASES_DIR/mode_manager.py"
    
    if [[ ! -f "$mode_manager" ]]; then
        echo "Error: mode_manager.py not found in $JUST_ALIASES_DIR"
        return 1
    fi
    
        # Handle interactive mode (no arguments) differently
    if [[ $# -eq 0 ]]; then
        # For interactive mode, run the Python script directly
        python "$mode_manager"
        
        # Read the selected mode from the config file
        local config_file="$JUST_ALIASES_DIR/.cache/just-aliases/selected_mode"
        if [[ -f "$config_file" ]]; then
            local selected_mode
            selected_mode=$(cat "$config_file")
            
            if [[ -n "$selected_mode" ]]; then
                # Rollback current mode if one is active
                if [[ -n "$__just_aliases_active_mode" ]]; then
                    local rollback_script="$JUST_ALIASES_DIR/.cache/just-aliases/${__just_aliases_active_mode}-rollback.zsh"
                    if [[ -f "$rollback_script" ]]; then
                        source "$rollback_script"
                    fi
                fi
                
                export __just_aliases_active_mode="$selected_mode"
                
                local apply_script="$JUST_ALIASES_DIR/.cache/just-aliases/${selected_mode}-apply.zsh"
                if [[ -f "$apply_script" ]]; then
                    source "$apply_script"
                    echo "✅ Applied mode: $selected_mode"
                else
                    echo "❌ Error: Apply script for mode '$selected_mode' not found."
                fi
                
                # Clean up the config file (optional - comment out if you want to keep it)
                # rm "$config_file"
            fi
        fi
        return
    fi

    # For non-interactive mode, use temp file approach
    local output_file
    output_file=$(mktemp)
    python "$mode_manager" "$@" > "$output_file"
    
    local output
    output=$(cat "$output_file")
    
    if [[ "$output" =~ export[[:space:]]+__just_aliases_active_mode= ]]; then
        local mode_name
        mode_name=$(echo "$output" | grep "export __just_aliases_active_mode=" | sed 's/export __just_aliases_active_mode=//')
        
        # Rollback current mode if one is active
        if [[ -n "$__just_aliases_active_mode" ]]; then
            local rollback_script="$JUST_ALIASES_DIR/.cache/just-aliases/${__just_aliases_active_mode}-rollback.zsh"
            if [[ -f "$rollback_script" ]]; then
                source "$rollback_script"
            fi
        fi
        
        # Set the new active mode
        export __just_aliases_active_mode="$mode_name"
        
        # Source the apply script for the new mode
        local apply_script="$JUST_ALIASES_DIR/.cache/just-aliases/${mode_name}-apply.zsh"
        if [[ -f "$apply_script" ]]; then
            source "$apply_script"
        fi
    fi
    
    cat "$output_file" | grep -v "export __just_aliases_active_mode="
    # rm "$output_file"  # Commented out to avoid removal prompts
}

# Function to list available modes
function ja-list() {
    python "$JUST_ALIASES_DIR/mode_manager.py" list
}

# Function to switch to a specific mode
function ja-switch() {
    if [[ -z "$1" ]]; then
        echo "Usage: ja-switch <mode_name>"
        return 1
    fi
    
    ja switch "$1"
}

# Function to build alias scripts
function build-aliases() {
    local build_script="$JUST_ALIASES_DIR/build-aliases.py"
    
    if [[ ! -f "$build_script" ]]; then
        echo "Error: build-aliases.py not found in $JUST_ALIASES_DIR"
        return 1
    fi
    
    python "$build_script"
}

# Function to show current mode
function ja-current() {
    if [[ -n "$__just_aliases_active_mode" ]]; then
        echo "Current active mode: $__just_aliases_active_mode"
    else
        echo "No mode currently active"
    fi
}

# Function to clear current mode (rollback without applying new mode)
function ja-clear() {
    if [[ -n "$__just_aliases_active_mode" ]]; then
        local rollback_script="$JUST_ALIASES_DIR/.cache/just-aliases/${__just_aliases_active_mode}-rollback.zsh"
        
        if [[ -f "$rollback_script" ]]; then
            echo "Clearing mode: $__just_aliases_active_mode"
            source "$rollback_script"
        fi
        
        unset __just_aliases_active_mode
        echo "Mode cleared"
    else
        echo "No mode currently active"
    fi
}

# Completion function for mode names
function _ja_completion() {
    local aliases_dir="$JUST_ALIASES_DIR/aliases"
    local modes=()
    
    if [[ -d "$aliases_dir" ]]; then
        for file in "$aliases_dir"/*; do
            if [[ -f "$file" ]]; then
                modes+=("$(basename "$file")")
            fi
        done
    fi
    
    _describe 'modes' modes
}

# Register completion for ja-switch function
compdef _ja_completion ja-switch

# Cross-directory bootstrap function
function xj() {
    local ja_dir="$HOME/dev/jazzydog-labs/foundry/just-aliases"
    local global_dir="$HOME/.just-aliases"
    
    # Check if global installation exists
    if [[ -f "$global_dir/justfile" ]]; then
        echo "🌍 Using global just-aliases installation..."
        just -f "$global_dir/justfile" all
        return 0
    fi
    
    # Fallback to local installation
    if [[ ! -d "$ja_dir" ]]; then
        echo "❌ Just-aliases directory not found at $ja_dir"
        echo "❌ Global installation not found at $global_dir"
        return 1
    fi
    
    # Save current directory
    local current_dir=$(pwd)
    
    # Change to just-aliases directory
    cd "$ja_dir"
    
    # Source the integration file to get access to jall
    if [[ -f "just-aliases.zsh" ]]; then
        source just-aliases.zsh
    fi
    
    # Run jall (which will build, source, and switch to build mode)
    if command -v jall >/dev/null 2>&1; then
        jall
    else
        echo "❌ jall command not found. Running manual bootstrap..."
        # Manual bootstrap: build, source, switch to build
        python just_aliases.py build
        source just-aliases.zsh
        ja switch build
    fi
    
    # Change back to original directory
    cd "$current_dir"
    
    echo "✅ Just-aliases bootstrapped from $ja_dir"
    echo "💡 You can now use 'ja' commands from anywhere!"
}

# Global just-aliases function
function gj() {
    local global_dir="$HOME/.just-aliases"
    
    if [[ ! -f "$global_dir/justfile" ]]; then
        echo "❌ Global just-aliases installation not found at $global_dir"
        echo "💡 Run 'xj' first to bootstrap the system"
        return 1
    fi
    
    just -f "$global_dir/justfile" "$@"
}

# Help function
function ja-help() {
    echo "just-aliases - Modal alias system for Zsh"
    echo ""
    echo "Commands:"
    echo "  ja                    - Interactive mode selection"
    echo "  ja list               - List all available modes"
    echo "  ja switch <mode>      - Switch to specific mode"
    echo "  ja-switch <mode>      - Alternative syntax for switching"
    echo "  ja-current            - Show current active mode"
    echo "  ja-clear              - Clear current mode"
    echo "  build-aliases         - Build mode scripts from aliases/ directory"
    echo "  xj                    - Bootstrap just-aliases from anywhere"
    echo "  gj <command>          - Use global just-aliases commands from anywhere"
    echo "  ja-help               - Show this help"
    echo ""
    echo "Usage:"
    echo "  1. Create mode files in the aliases/ directory"
    echo "  2. Run 'build-aliases' to generate scripts"
    echo "  3. Use 'ja' to switch between modes"
    echo "  4. Use 'xj' to bootstrap from anywhere"
    echo "  5. Use 'gj <command>' for global commands from anywhere"
} 