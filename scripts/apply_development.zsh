#!/bin/zsh
# Apply script for mode: development

echo "🎯 Applying mode: development"

# First rollback any existing aliases
source "$(dirname "$0")/rollback.zsh"

# Source the mode file
source "$(dirname "$0")/../aliases/development.zsh"

# Set the current mode
export JA_CURRENT_MODE="development"

echo "✅ Mode 'development' applied"
