#!/bin/bash
# Remove all just-aliases integration touchpoints from the system

set -e

CUSTOM_DIR="$HOME/.oh-my-zsh/custom/jazzydog-labs"
CONFIG_DIR="$HOME/.config/jazzydog-labs"
GLOBAL_DIR="$HOME/.just-aliases"
ZSHRC="$HOME/.zshrc"

# Remove copied bootstrap scripts
if [ -d "$CUSTOM_DIR" ]; then
    rm -rf "$CUSTOM_DIR"
    echo "Removed $CUSTOM_DIR"
fi

# Remove modular loading snippet from .zshrc
if grep -q "#START: Load all custom modular scripts" "$ZSHRC"; then
    sed -i '' '/#START: Load all custom modular scripts/,/#END: Load all custom modular scripts/d' "$ZSHRC"
    echo "Removed modular loading code from $ZSHRC"
fi

# Remove any line sourcing just-aliases.zsh
if grep -q "just-aliases.zsh" "$ZSHRC"; then
    sed -i '' '/just-aliases.zsh/d' "$ZSHRC"
    echo "Removed just-aliases source line from $ZSHRC"
fi

# Remove global installation
if [ -d "$GLOBAL_DIR" ]; then
    rm -rf "$GLOBAL_DIR"
    echo "Removed $GLOBAL_DIR"
fi

# Remove config directory
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo "Removed $CONFIG_DIR"
fi

echo "✅ just-aliases touchpoints removed"
