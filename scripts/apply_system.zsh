#!/bin/zsh
# Apply script for mode: system

echo "🎯 Applying mode: system"

# First rollback any existing aliases
source "$(dirname "$0")/rollback.zsh"

# Source the mode file
source "$(dirname "$0")/../aliases/system.zsh"

# Set the current mode
export JA_CURRENT_MODE="system"

echo "✅ Mode 'system' applied"
