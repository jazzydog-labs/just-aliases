# just-aliases

A modal alias system for Zsh that allows you to switch between different sets of aliases dynamically.

## Overview

just-aliases provides a clean way to organize your shell aliases into different "modes" (e.g., development, system administration, minimal) and switch between them seamlessly. Each mode corresponds to a file in the `aliases/` directory containing plain Zsh alias definitions.

## Features

- **Modal alias switching**: Switch between different alias sets with a single command
- **Safe rollback**: Only restores aliases that haven't been modified since activation
- **No session persistence**: All switching is done dynamically per invocation
- **Interactive selection**: Choose modes from a numbered list
- **Shell integration**: Simple `m` command for mode management

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd just-aliases
   ```

2. Source the shell integration in your `.zshrc`:
   ```bash
   echo "source $(pwd)/just-aliases.zsh" >> ~/.zshrc
   ```

3. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

## Usage

### Basic Commands

- `m` - Interactive mode selection
- `m list` - List all available modes
- `m switch <mode>` - Switch to specific mode
- `m-current` - Show current active mode
- `m-clear` - Clear current mode (rollback)
- `build-aliases` - Build mode scripts from aliases/ directory
- `m-help` - Show help

### Creating Modes

1. Create a new file in the `aliases/` directory:
   ```bash
   touch aliases/my-mode
   ```

2. Add alias definitions to the file:
   ```bash
   # aliases/my-mode
   alias ll='ls -la'
   alias dev='cd ~/dev'
   alias gs='git status'
   ```

3. Build the mode scripts:
   ```bash
   build-aliases
   ```

4. Switch to your new mode:
   ```bash
   m switch my-mode
   ```

### Example Workflow

```bash
# List available modes
$ m list
Available modes:
  1. development *
  2. minimal
  3. system

Current active mode: development

# Switch to minimal mode
$ m switch minimal
Rolling back mode: development
Applying mode: minimal

# Check current mode
$ m-current
Current active mode: minimal

# Switch back to development
$ m
Available modes:
  1. development
  2. minimal *
  3. system

Current active mode: minimal

Select mode (number or name, or 'q' to quit): 1
Rolling back mode: minimal
Applying mode: development
```

## How It Works

### Mode Switching Process

1. **Rollback**: The system sources the rollback script from the current mode, which restores original alias definitions only if they haven't been modified since activation.

2. **Apply**: The system sources the apply script from the new mode, which defines all aliases for that mode.

3. **State Tracking**: The current active mode is tracked via the `__just_aliases_active_mode` environment variable.

### Build Process

The `build-aliases` script:

1. Scans the `aliases/` directory for mode files
2. For each mode, analyzes the alias definitions
3. Checks the current shell for existing aliases
4. Generates three files per mode:
   - `<mode>-apply.zsh` - Defines the mode's aliases
   - `<mode>-rollback.zsh` - Restores original aliases (if unchanged)
   - `<mode>-snapshot.zsh` - Records original alias state

### Safety Features

- **Non-destructive**: User-modified aliases are preserved during mode switches
- **Rollback protection**: Only restores aliases that still match the original definition
- **Clean state**: No global state tracking across sessions

## File Structure

```
just-aliases/
├── aliases/                    # Mode definition files
│   ├── development            # Development mode aliases
│   ├── system                 # System administration aliases
│   └── minimal                # Minimal aliases
├── .cache/just-aliases/       # Generated scripts (auto-created)
│   ├── development-apply.zsh
│   ├── development-rollback.zsh
│   ├── development-snapshot.zsh
│   └── ...
├── mode_manager.py            # Mode switching logic
├── build-aliases.py           # Script generation
├── just-aliases.zsh           # Shell integration
└── README.md                  # This file
```

## Example Modes

### Development Mode
```bash
# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# Development tools
alias py='python3'
alias serve='python3 -m http.server'
alias dev='cd ~/dev'
```

### System Mode
```bash
# System administration
alias update='brew update && brew upgrade'
alias cpu='top -l 1 | head -n 10'
alias mem='top -l 1 | head -n 4 | tail -n 1'

# Network utilities
alias myip='curl ifconfig.me'
alias pingg='ping google.com'
```

### Minimal Mode
```bash
# Basic operations only
alias ll='ls -la'
alias c='clear'
alias home='cd ~'
```

## Troubleshooting

### Mode not found
- Ensure the mode file exists in `aliases/` directory
- Run `build-aliases` to generate scripts
- Check that the mode name matches the filename exactly

### Aliases not applying
- Verify the mode file contains valid alias definitions
- Check that `build-aliases` completed successfully
- Ensure the `.cache/just-aliases/` directory contains the generated scripts

### Shell integration not working
- Verify `just-aliases.zsh` is sourced in your `.zshrc`
- Check that Python 3 is available
- Ensure the script paths are correct

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is open source. Please check the license file for details. 