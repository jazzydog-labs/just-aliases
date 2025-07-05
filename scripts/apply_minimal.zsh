#!/bin/zsh
# Apply script for mode: minimal

echo "🎯 Applying mode: minimal"

# First rollback any existing aliases
source "$(dirname "$0")/rollback.zsh"

# Source the mode file
source "$(dirname "$0")/../aliases/minimal.zsh"

# Set the current mode
export JA_CURRENT_MODE="minimal"

echo "✅ Mode 'minimal' applied"
