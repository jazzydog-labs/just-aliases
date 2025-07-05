import os
import shutil
import typer
from pathlib import Path
from typing import Optional

app = typer.Typer()

def get_aliases_dir() -> Path:
    """Get the aliases directory path."""
    return Path("aliases")

def get_scripts_dir() -> Path:
    """Get the scripts directory path."""
    return Path("scripts")

def get_global_dir() -> Path:
    """Get the global just-aliases directory path."""
    return Path.home() / ".just-aliases"

def ensure_directories():
    """Ensure all necessary directories exist."""
    get_aliases_dir().mkdir(exist_ok=True)
    get_scripts_dir().mkdir(exist_ok=True)
    get_global_dir().mkdir(exist_ok=True)

def get_mode_files() -> list[Path]:
    """Get all mode files from the aliases directory."""
    aliases_dir = get_aliases_dir()
    if not aliases_dir.exists():
        return []
    
    # Get all .zsh files and files without extensions
    mode_files = []
    for file_path in aliases_dir.iterdir():
        if file_path.is_file():
            # Include .zsh files and files without extensions
            if file_path.suffix == '.zsh' or file_path.suffix == '':
                mode_files.append(file_path)
    
    return sorted(mode_files)

def get_mode_name(file_path: Path) -> str:
    """Get the mode name from a file path (strip .zsh extension)."""
    return file_path.stem

def build_rollback_script():
    """Build the rollback script that clears all aliases."""
    scripts_dir = get_scripts_dir()
    rollback_script = scripts_dir / "rollback.zsh"
    
    content = """#!/bin/zsh
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
"""
    
    rollback_script.write_text(content)
    rollback_script.chmod(0o755)
    print(f"✅ Built rollback script: {rollback_script}")

def build_apply_script(mode_name: str, mode_file: Path):
    """Build an apply script for a specific mode."""
    scripts_dir = get_scripts_dir()
    apply_script = scripts_dir / f"apply_{mode_name}.zsh"
    
    content = f"""#!/bin/zsh
# Apply script for mode: {mode_name}

echo "🎯 Applying mode: {mode_name}"

# First rollback any existing aliases
source "$(dirname "$0")/rollback.zsh"

# Source the mode file
source "$(dirname "$0")/../aliases/{mode_file.name}"

# Set the current mode
export JA_CURRENT_MODE="{mode_name}"

echo "✅ Mode '{mode_name}' applied"
"""
    
    apply_script.write_text(content)
    apply_script.chmod(0o755)
    print(f"✅ Built apply script: {apply_script}")

def build_global_justfile():
    """Build a global justfile in ~/.just-aliases/."""
    global_dir = get_global_dir()
    global_justfile = global_dir / "justfile"
    
    content = """# Global just-aliases justfile
# This justfile provides access to just-aliases commands from anywhere

# Bootstrap the just-aliases system
bootstrap:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    python just_aliases.py build
    source just-aliases.zsh
    ja switch build

# Build the alias scripts
build:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    python just_aliases.py build

# Source the integration
source:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    source just-aliases.zsh

# Switch to a specific mode
switch mode:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    source just-aliases.zsh
    ja switch {{mode}}

# List available modes
list:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    source just-aliases.zsh
    ja list

# Show current mode
current:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    source just-aliases.zsh
    ja-current

# Clear current mode
clear:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    source just-aliases.zsh
    ja-clear

# Run all bootstrap steps
all:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    python just_aliases.py build
    source just-aliases.zsh
    ja switch build

# Show help
help:
    #!/usr/bin/env bash
    cd ~/dev/jazzydog-labs/foundry/just-aliases
    source just-aliases.zsh
    ja-help
"""
    
    global_justfile.write_text(content)
    print(f"✅ Built global justfile: {global_justfile}")

def copy_to_global():
    """Copy generated files to the global directory."""
    global_dir = get_global_dir()
    scripts_dir = get_scripts_dir()
    aliases_dir = get_aliases_dir()
    
    # Copy scripts directory
    global_scripts = global_dir / "scripts"
    if global_scripts.exists():
        shutil.rmtree(global_scripts)
    shutil.copytree(scripts_dir, global_scripts)
    
    # Copy aliases directory
    global_aliases = global_dir / "aliases"
    if global_aliases.exists():
        shutil.rmtree(global_aliases)
    shutil.copytree(aliases_dir, global_aliases)
    
    # Copy the integration file
    integration_file = Path("just-aliases.zsh")
    if integration_file.exists():
        shutil.copy2(integration_file, global_dir)
    
    print(f"✅ Copied files to global directory: {global_dir}")

@app.command()
def build():
    """Build mode scripts from aliases directory."""
    ensure_directories()
    
    mode_files = get_mode_files()
    
    if not mode_files:
        print("❌ No mode files found in aliases/ directory")
        print("   Create some mode files (e.g., aliases/development.zsh) first")
        return
    
    print(f"🔨 Building scripts for {len(mode_files)} modes...")
    
    # Build rollback script first
    build_rollback_script()
    
    # Build apply scripts for each mode
    for mode_file in mode_files:
        mode_name = get_mode_name(mode_file)
        build_apply_script(mode_name, mode_file)
    
    # Build global justfile
    build_global_justfile()
    
    # Copy everything to global directory
    copy_to_global()
    
    print(f"✅ Built {len(mode_files)} mode scripts")
    print(f"🌍 Global installation available at: {get_global_dir()}")
    print(f"💡 Use 'just -f ~/.just-aliases/justfile <command>' from anywhere")

@app.command()
def list():
    """List all available modes."""
    mode_files = get_mode_files()
    
    if not mode_files:
        print("❌ No mode files found in aliases/ directory")
        return
    
    print("📋 Available modes:")
    for mode_file in mode_files:
        mode_name = get_mode_name(mode_file)
        print(f"  • {mode_name}")

@app.command()
def switch(mode: str):
    """Switch to a specific mode."""
    mode_files = get_mode_files()
    mode_names = [get_mode_name(f) for f in mode_files]
    
    if mode not in mode_names:
        print(f"❌ Mode '{mode}' not found")
        print(f"   Available modes: {', '.join(mode_names)}")
        return
    
    # Find the apply script and run it
    apply_script = get_scripts_dir() / f"apply_{mode}.zsh"
    if apply_script.exists():
        os.system(f"source {apply_script}")
    else:
        print(f"❌ Apply script for mode '{mode}' not found")
        print("   Run 'python just_aliases.py build' first")

if __name__ == "__main__":
    app() 