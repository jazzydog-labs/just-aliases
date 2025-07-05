#!/bin/zsh
# Rollback script - clears all aliases and functions

echo "🔄 Rolling back all aliases..."

# Clear all aliases
unalias -a

# Clear just-aliases specific functions (keep core ones)
unset -f ja 2>/dev/null || true
unset -f ja-switch 2>/dev/null || true
unset -f ja-current 2>/dev/null || true
unset -f ja-clear 2>/dev/null || true
unset -f build-aliases 2>/dev/null || true
unset -f ja-help 2>/dev/null || true

# Clear the current mode variable
unset JA_CURRENT_MODE

echo "✅ All aliases cleared"
