#!/bin/bash

mkdir -p ~/.config/jazzydog-labs

# Copy the project .config to ~/.config/jazzydog-labs/.config
cp .config.yaml ~/.config/jazzydog-labs/.config.yaml

# source all bootstrap files in order
for file in bootstrap/*.bootstrap.zsh; do
    source "$file"
done
EXPERT_MODE=$(get_config "expert-mode")

# Setup script for modular loading system
# only show if expert-mode is false
if [[ "$EXPERT_MODE" == "false" ]]; then
    echo "🔧 Setting up modular loading system..."
fi

# Create ~/.oh-my-zsh/custom/ directory if it doesn't exist
CUSTOM_DIR="$HOME/.oh-my-zsh/custom/jazzydog-labs"
mkdir -p "$CUSTOM_DIR"

# Copy all files from bootstrap directory to oh-my-zsh custom directory
# with numbered prefixes to maintain order
for file in bootstrap/*.zsh; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        cp "$file" "$CUSTOM_DIR/${filename}"
        if [[ "$EXPERT_MODE" == "false" ]]; then
            echo "✅ Copied $file to $CUSTOM_DIR/${filename}"
        fi
    fi
done

# delete the modular loading code from .zshrc if it exists
if grep -q "#START: Load all custom modular scripts" ~/.zshrc; then
    # macOS sed requires an empty string for -i flag
    sed -i '' '/#START: Load all custom modular scripts/,/#END: Load all custom modular scripts/d' ~/.zshrc
    if [[ "$EXPERT_MODE" == "false" ]]; then
        echo "✅ Removed modular loading code from .zshrc"
    fi
fi


# Build the echo statement conditionally
ECHO_STATEMENT=""
if [[ "$EXPERT_MODE" == "false" ]]; then
    ECHO_STATEMENT='        echo "sourcing $custom_script"'
fi

# Add the modular loading code to .zshrc (it doesn't exist here since we deleted it)
cat >> ~/.zshrc << EOF
#START: Load all custom modular scripts in $CUSTOM_DIR in order
for custom_script in "$CUSTOM_DIR"/*.zsh; do
    if [[ -f "\$custom_script" ]]; then
$ECHO_STATEMENT
        source "\$custom_script"
    fi
done
#END: Load all custom modular scripts in $CUSTOM_DIR in order
EOF

if [[ "$EXPERT_MODE" == "false" ]]; then
    echo "✅ Added modular loading code to .zshrc"
fi

# Show completion message if not in expert mode
if [[ "$EXPERT_MODE" == "false" ]]; then
    echo ""
    echo "🎉 Setup complete!"
    echo "💡 The bootstrap aliases will load automatically in new shells"
    echo "💡 You can add more numbered scripts to ~/.oh-my-zsh/custom/ (e.g., 002_*, 003_*)"
    echo "💡 They will load in numerical order"
fi 