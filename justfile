# just-aliases - Modal alias system for Zsh
# Justfile for common development tasks

# Default recipe - show help
default:
    @just --list

# Build all mode scripts from aliases/ directory
build:
    @echo "🔨 Building alias scripts..."
    python just_aliases.py build

# Source the shell integration in current shell
source:
    @echo "source $(pwd)/just-aliases.zsh"

# Install - build scripts and source integration
install: build
    @echo "📦 Installing just-aliases..."
    @echo "Run 'source just-aliases.zsh' to enable the 'ja' command"
    @echo "Or add 'source $(pwd)/just-aliases.zsh' to your .zshrc"

# Test the system by listing modes
test:
    @echo "🧪 Testing just-aliases..."
    @echo "Listing available modes:"
    python just_aliases.py list

# Interactive mode selection
interactive:
    @echo "🎯 Interactive mode selection..."
    source just-aliases.zsh
    ja

# Switch to a specific mode
switch mode:
    @echo "🔄 Switching to mode: {{mode}}"
    source just-aliases.zsh
    ja switch {{mode}}

# Show current active mode
current:
    @echo "📋 Current active mode:"
    source just-aliases.zsh
    ja-current

# Clean generated files
clean:
    @echo "🧹 Cleaning generated files..."
    rm -rf .cache/
    @echo "✅ Cleaned!"

# Show project status
status:
    @echo "📊 Project Status:"
    @echo "Available modes:"
    @ls -1 aliases/ 2>/dev/null || echo "  No modes found"
    @echo ""
    @echo "Generated scripts:"
    @ls -1 .cache/just-aliases/ 2>/dev/null || echo "  No scripts found (run 'just build')"
    @echo ""
    @echo "Current active mode:"
    @if [ -f .cache/just-aliases/selected_mode ]; then \
        echo "  $(cat .cache/just-aliases/selected_mode)"; \
    else \
        echo "  None"; \
    fi

# Create a new mode
new-mode name:
    @echo "📝 Creating new mode: {{name}}"
    @touch aliases/{{name}}
    @echo "# {{name}} mode aliases" > aliases/{{name}}
    @echo "# Add your aliases here:" >> aliases/{{name}}
    @echo "# alias example='echo hello'" >> aliases/{{name}}
    @echo "✅ Created aliases/{{name}}"
    @echo "📝 Edit the file and run 'just build' to generate scripts"

# Show help
help:
    @echo "just-aliases - Modal alias system for Zsh"
    @echo ""
    @echo "Available commands:"
    @echo "  just build        - Build all mode scripts"
    @echo "  just source       - Source shell integration"
    @echo "  just install      - Build and show install instructions"
    @echo "  just test         - Test the system"
    @echo "  just interactive  - Interactive mode selection"
    @echo "  just switch <mode> - Switch to specific mode"
    @echo "  just current      - Show current mode"
    @echo "  just clean        - Clean generated files"
    @echo "  just status       - Show project status"
    @echo "  just new-mode <name> - Create a new mode"
    @echo "  just help         - Show this help"
    @echo ""
    @echo "Global commands (use from anywhere):"
    @echo "  just global-build  - Build using global installation"
    @echo "  just global-all    - Bootstrap using global installation"
    @echo "  just global-switch <mode> - Switch mode globally"
    @echo "  just global-list   - List modes globally"
    @echo ""
    @echo "Usage:"
    @echo "  1. just build     # Generate scripts"
    @echo "  2. just source    # Enable in current shell"
    @echo "  3. ja             # Switch modes interactively"
    @echo "  4. xj             # Bootstrap from anywhere"
    @echo "  5. gj <command>   # Use global commands from anywhere"

# Development helpers
dev-setup: build
    @echo "🚀 Development environment ready!"
    @echo "Run 'source $(pwd)/just-aliases.zsh' to enable the 'ja' command"
    @echo "Then try: ja"

# Quick test of a mode
test-mode mode:
    @echo "🧪 Testing mode: {{mode}}"
    @if [ -f aliases/{{mode}} ]; then \
        echo "Mode file exists:"; \
        cat aliases/{{mode}}; \
        echo ""; \
        echo "Generated scripts:"; \
        ls -la scripts/apply_{{mode}}.zsh 2>/dev/null || echo "  No scripts found (run 'just build')"; \
    else \
        echo "❌ Mode '{{mode}}' not found"; \
    fi

# Global commands (use from anywhere)
global-build:
    @echo "🌍 Building using global installation..."
    just -f ~/.just-aliases/justfile build

global-source:
    @echo "🌍 Sourcing using global installation..."
    just -f ~/.just-aliases/justfile source

global-switch mode:
    @echo "🌍 Switching to mode: {{mode}} using global installation..."
    just -f ~/.just-aliases/justfile switch {{mode}}

global-list:
    @echo "🌍 Listing modes using global installation..."
    just -f ~/.just-aliases/justfile list

global-current:
    @echo "🌍 Current mode using global installation..."
    just -f ~/.just-aliases/justfile current

global-clear:
    @echo "🌍 Clearing mode using global installation..."
    just -f ~/.just-aliases/justfile clear

global-all:
    @echo "🌍 Bootstrap using global installation..."
    just -f ~/.just-aliases/justfile all

global-help:
    @echo "🌍 Help using global installation..."
    just -f ~/.just-aliases/justfile help 