#!/bin/zsh
# Apply script for mode: build

echo "🎯 Applying mode: build"

# First rollback any existing aliases
source "$(dirname "$0")/rollback.zsh"

# Source the mode file
source "$(dirname "$0")/../aliases/build.zsh"

# Set the current mode
export JA_CURRENT_MODE="build"

echo "✅ Mode 'build' applied"
