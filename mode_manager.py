#!/usr/bin/env python3
"""
Modal alias system for Zsh - Mode Manager (Typer CLI)

This script handles listing available modes, user selection, and mode switching.
"""

import os
import subprocess
from pathlib import Path
from typing import List, Optional
import typer

app = typer.Typer(help="Manage just-aliases modes.")

class ModeManager:
    def __init__(self):
        self.aliases_dir = Path("aliases")
        self.cache_dir = Path(".cache/just-aliases")
        self.active_mode_var = "__just_aliases_active_mode"
    
    def get_available_modes(self) -> List[str]:
        """Get list of available modes from aliases directory."""
        if not self.aliases_dir.exists():
            return []
        
        modes = []
        for file_path in self.aliases_dir.iterdir():
            if file_path.is_file() and file_path.suffix == ".zsh":
                # Strip .zsh extension for mode name
                mode_name = file_path.stem
                modes.append(mode_name)
        
        return sorted(modes)
    
    def get_current_mode(self) -> Optional[str]:
        """Get the currently active mode from shell environment."""
        return os.environ.get(self.active_mode_var)
    
    def list_modes(self):
        """List all available modes and highlight the current one."""
        modes = self.get_available_modes()
        current_mode = self.get_current_mode()
        
        if not modes:
            typer.secho("No modes found in aliases/ directory.", fg=typer.colors.RED, bold=True)
            return
        
        typer.secho("\nAvailable modes:", fg=typer.colors.CYAN, bold=True)
        for i, mode in enumerate(modes, 1):
            if mode == current_mode:
                typer.secho(f"  {i}. {mode}  [32m[ACTIVE][0m ✅", fg=typer.colors.GREEN, bold=True)
            else:
                typer.secho(f"  {i}. {mode}", fg=typer.colors.WHITE)
        
        if current_mode:
            typer.secho(f"\nCurrent active mode: {current_mode}", fg=typer.colors.GREEN, bold=True)
        else:
            typer.secho("\nNo mode currently active", fg=typer.colors.YELLOW)
    
    def select_mode(self) -> Optional[str]:
        """Show mode selection interface and return selected mode."""
        modes = self.get_available_modes()
        current_mode = self.get_current_mode()
        
        if not modes:
            typer.secho("No modes found in aliases/ directory.", fg=typer.colors.RED, bold=True)
            return None
        
        typer.secho("\nAvailable modes:", fg=typer.colors.CYAN, bold=True)
        for i, mode in enumerate(modes, 1):
            if mode == current_mode:
                typer.secho(f"  {i}. {mode}  [32m[ACTIVE][0m ✅", fg=typer.colors.GREEN, bold=True)
            else:
                typer.secho(f"  {i}. {mode}", fg=typer.colors.WHITE)
        
        if current_mode:
            typer.secho(f"\nCurrent active mode: {current_mode}", fg=typer.colors.GREEN, bold=True)
        
        try:
            choice = typer.prompt("\nSelect mode (number or name, or 'q' to quit)").strip()
            
            if choice.lower() == 'q':
                return None
            
            # Try to parse as number
            try:
                index = int(choice) - 1
                if 0 <= index < len(modes):
                    return modes[index]
                else:
                    typer.secho("Invalid selection.", fg=typer.colors.RED)
                    return None
            except ValueError:
                # Try to match by name
                if choice in modes:
                    return choice
                else:
                    typer.secho("Invalid mode name.", fg=typer.colors.RED)
                    return None
                    
        except (EOFError, KeyboardInterrupt):
            typer.secho("\nCancelled.", fg=typer.colors.YELLOW)
            return None
    
    def switch_mode(self, new_mode: str):
        """Switch to the specified mode by sourcing rollback and apply scripts."""
        current_mode = self.get_current_mode()
        
        # Note: Rollback and apply will be handled by the shell function
        if current_mode:
            typer.secho(f"\n↩️  Rolling back mode: {current_mode}", fg=typer.colors.YELLOW, bold=True)
        
        # Check if apply script exists
        apply_script = self.cache_dir / f"{new_mode}-apply.zsh"
        if apply_script.exists():
            typer.secho(f"\n➡️  Applying mode: {new_mode}", fg=typer.colors.CYAN, bold=True)
            self._set_active_mode(new_mode)
        else:
            typer.secho(f"\n❌ Error: Apply script for mode '{new_mode}' not found.", fg=typer.colors.RED, bold=True)
            typer.secho("Run 'build-aliases' to generate mode scripts.", fg=typer.colors.YELLOW)
    
    def _source_script(self, script_path: Path):
        """Source a Zsh script in the current shell."""
        if not script_path.exists():
            typer.secho(f"Warning: Script {script_path} not found.", fg=typer.colors.RED)
            return
        
        # Use source command to execute the script in the current shell
        subprocess.run(["zsh", "-c", f"source {script_path}"], check=True)
    
    def _set_active_mode(self, mode: str):
        """Set the active mode environment variable."""
        # Write the mode to a config file for the shell function to read
        config_file = Path(".cache/just-aliases/selected_mode")
        config_file.parent.mkdir(parents=True, exist_ok=True)
        with open(config_file, 'w') as f:
            f.write(mode)
        
        # Also print the export command for backward compatibility
        typer.secho(f"export {self.active_mode_var}={mode}", fg=typer.colors.GREEN)

manager = ModeManager()

@app.command()
def list():
    """List all available modes."""
    manager.list_modes()

@app.command()
def switch(mode: Optional[str] = typer.Argument(None, help="Mode name to switch to (optional, will prompt if not provided)")):
    """Switch to a specific mode (or prompt to select)."""
    if mode is None:
        selected_mode = manager.select_mode()
        if selected_mode:
            manager.switch_mode(selected_mode)
    else:
        manager.switch_mode(mode)

@app.command()
def interactive():
    """Interactive mode selection (default if no command given)."""
    selected_mode = manager.select_mode()
    if selected_mode:
        manager.switch_mode(selected_mode)

if __name__ == "__main__":
    # If no arguments provided, run interactive mode by default
    import sys
    if len(sys.argv) == 1:
        selected_mode = manager.select_mode()
        if selected_mode:
            manager.switch_mode(selected_mode)
    else:
        app() 