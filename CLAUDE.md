# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

just-aliases is a modal alias system for Zsh that allows users to switch between different sets of shell aliases dynamically. The system provides clean rollback capabilities and avoids permanent shell modifications.

## Key Commands

### Development Commands
- `just build` - Generate apply/rollback scripts from alias definitions in `aliases/`
- `just test` - List available modes (basic functionality test)
- `just status` - Show project status including available modes and active mode
- `just clean` - Remove generated files (.cache/)
- `just new-mode <name>` - Create a new alias mode file

### Installation & Usage
- `just bootstrap` - Set up the modular loading system
- `just install` - Build scripts and show installation instructions
- `source just-aliases.zsh` - Enable shell integration in current session

### Runtime Commands (after sourcing)
- `ja` - Interactive mode selection
- `ja-list` - List available modes
- `ja-switch <mode>` - Activate a specific mode
- `ja-current` - Show active mode
- `ja-clear` - Roll back active mode
- `build-aliases` - Rebuild scripts (wrapper for `just build`)

## Architecture

### Core Components
- **just_aliases.py**: Main build script using Typer CLI that generates apply/rollback scripts for each mode
- **mode_manager.py**: Interactive mode selection UI with numbered interface
- **just-aliases.zsh**: Shell integration providing the `ja` command family

### Directory Structure
```
aliases/              # Mode definition files (*.zsh)
scripts/              # Generated apply/rollback scripts
bootstrap/           # oh-my-zsh integration scripts
.cache/just-aliases/ # Runtime state and generated scripts
```

### Key Concepts
1. **Modes**: Each file in `aliases/` defines a set of aliases that can be activated together
2. **Apply/Rollback**: Each mode generates two scripts - one to apply aliases and one to cleanly remove them
3. **State Management**: Active mode tracked in `.cache/just-aliases/selected_mode`
4. **Global Installation**: System can be installed to `~/.just-aliases` for cross-directory usage

## Development Workflow

1. Create or edit mode files in `aliases/` directory
2. Run `just build` to generate apply/rollback scripts
3. Use `ja` or `ja-switch <mode>` to activate modes
4. Changes to alias files require rebuilding with `just build`

## Testing Approach

Currently no automated tests. Testing is manual:
- `just test` lists available modes
- `just test-mode <mode>` shows mode file contents
- Manual verification of alias activation/rollback

## Important Notes

- The project uses `just` task runner (not Make or npm scripts)
- No package dependencies - pure Python stdlib and shell scripts
- No linting or formatting tools configured
- Active development with TODO items focused on workflow improvements



## Task Management System

This project uses a commit-based task tracking system. Tasks are organized as numbered markdown files in the `commits/` directory:

- `commits/open/` - Contains pending tasks to be implemented
- `commits/closed/` - Contains completed tasks

## Working on Tasks

When implementing a task:
1. Choose a task from `commits/open/` (e.g., `0003_expand_prompt_generation.md`)
2. Read the task description and requirements
3. Implement the changes as specified
4. As part of your commit, move the task file from `open/` to `closed/`:
   ```bash
   git mv commits/open/0003_expand_prompt_generation.md commits/closed/
   git add [your implementation files]
   git commit -m "feat: expand prompt generation logic

   - [implementation details]
   
   Closes: commits/open/0003_expand_prompt_generation.md"
   ```

### Current Open Tasks

Check `commits/open/` for available tasks. Each file contains:
- Detailed requirements
- Proposed implementation approach
- Files that need to be changed
- Architecture considerations


## Demo Guidelines

When creating demos, ALWAYS start with a "killer feature" that is:
- **Concise**: Show the most impressive capability in 2-3 lines of code
- **Attention-grabbing**: Demonstrate immediate value
- **To the point**: No setup, just the wow factor
- **Practical**: Show why users should care

Example format:
```python
def demo_killer_feature():
    """The ONE thing that makes this feature amazing."""
    print("=== KILLER FEATURE: Transform any idea into 10 refined versions in seconds ===")
    idea = Idea.create("Basic concept", score=5.0)
    best_version = idea.auto_refine(iterations=10).get_best_version()
    print(f"Original score: 5.0 → Best score: {best_version.score} (+{best_version.score - 5.0} improvement!)")
```

Then proceed with the detailed demo sections.